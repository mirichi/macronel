# Loads Spinel's text AST format into a node table object.
#
# The table object supplies the parallel-array storage operations used by
# Compiler: alloc_node, set_root_id, set_node_type, set_node_content, and
# set_*_field.

class NodeTableLoader
  def initialize(table)
    @table = table
  end

  def read_text_ast(data)
    lines = data.split(10.chr)
    # Strip trailing \r/\n from each line using safe character scanning
    idx = 0
    while idx < lines.length
      line = lines[idx].to_s
      clean_line = ""
      ch_idx = 0
      while ch_idx < line.length
        ch = line[ch_idx].to_s
        if ch != "\r" && ch != "\n"
          clean_line << ch
        end
        ch_idx = ch_idx + 1
      end
      lines[idx] = clean_line.to_s
      idx = idx + 1
    end
 # Pass 1: find max node ID
    max_id = 0
    i = 0
    while i < lines.length
      line = lines[i]
      if line.length > 0
        parts = line.split(" ")
        if parts.length >= 2
          if parts.first == "ROOT"
            @table.set_root_id(parts[1].to_i)
          end
 # Issue #878: SOURCE_FILE <escaped-path> appears once near the
 # top of the AST. Loader stashes the unescaped path on the
 # table so __dir__ et al. can recover it without scanning
 # SourceFileNode entries (which only exist if the source
 # references __FILE__).
          if parts.first == "SOURCE_FILE"
            if parts.length >= 2
              @table.set_source_file_path(unescape_str(parts[1]))
            end
          end
 # Debug multi-file map (FILE <id> <escaped-path>): records which
 # original file each node's `node_file` id refers to, so codegen can
 # emit `#line N "file"` across require_relative-inlined sources.
          if parts.first == "FILE"
            if parts.length >= 3
              @table.set_file_entry(parts[1].to_i, unescape_str(parts[2]))
            end
          end
          if parts.first == "N"
            nid = parts[1].to_i
            if nid > max_id
              max_id = nid
            end
          end
        end
      end
      i = i + 1
    end
 # Allocate all node slots in one bulk presize pass instead of
 # max_id+1 separate alloc_node calls. The bulk path avoids ~46 * N
 # Array#push operations (and their amortized realloc events).
    @table.alloc_nodes(max_id + 1)
 # Pass 2: populate fields
    i = 0
    while i < lines.length
      line = lines[i]
      if line.length > 0
        ast_parse_line(line)
      end
      i = i + 1
    end
  end

  def ast_parse_line(line)
    parts = line.split(" ")
    if parts.length < 3
      return
    end
    tag = parts.first
    nid = parts[1].to_i
    if tag == "N"
      @table.set_node_type(nid, parts[2])
    elsif tag == "S"
      field = parts[2]
      val = ""
      if parts.length >= 4
        val = unescape_str(parts[3])
      end
      @table.set_string_field(nid, field, val)
    elsif tag == "I"
      field = parts[2]
      ival = 0
      if parts.length >= 4
        ival = parts[3].to_i
      end
      @table.set_int_field(nid, field, ival)
    elsif tag == "F"
      if parts.length >= 4
        @table.set_node_content(nid, parts[3])
      end
    elsif tag == "R"
      field = parts[2]
      ref_id = -1
      if parts.length >= 4
        ref_id = parts[3].to_i
      end
      @table.set_ref_field(nid, field, ref_id)
    elsif tag == "A"
      field = parts[2]
      ids_str = ""
      if parts.length >= 4
        ids_str = parts[3]
      end
      @table.set_array_field(nid, field, ids_str)
    end
    0
  end

  def unescape_str(s)
    result = ""
    i = 0
    while i < s.length
      ch = s[i]
      if ch == "%"
        if i + 2 < s.length
          hex = s[i + 1] + s[i + 2]
          case hex
          when "0A"
            result = result + 10.chr
          when "0D"
            result = result + 13.chr
          when "09"
            result = result + 9.chr
          when "20"
            result = result + " "
          when "25"
            result = result + "%"
          when "00"
 # Issue #722: NUL byte (literal embedded in a Ruby string).
            result = result + 0.chr
          else
            result = result + "%" + hex
          end
          i = i + 3
        else
          result = result + ch
          i = i + 1
        end
      else
        result = result + ch
        i = i + 1
      end
    end
    result
  end
end

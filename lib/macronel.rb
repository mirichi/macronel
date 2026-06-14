# lib/macronel.rb
# Core Macronel engine

require_relative '../node_table_loader'

class MacronelTable
  attr_accessor :root_id, :source_file_path
  attr_accessor :nd_type, :nd_name, :nd_value, :nd_content, :nd_flags, :nd_operator, :nd_binop, :nd_callop
  attr_accessor :nd_receiver, :nd_arguments, :nd_body, :nd_block, :nd_parameters, :nd_predicate, :nd_subsequent
  attr_accessor :nd_else_clause, :nd_left, :nd_right, :nd_constant_path, :nd_superclass, :nd_rest
  attr_accessor :nd_keyword_rest, :nd_rescue_clause, :nd_ensure_clause, :nd_expression, :nd_target, :nd_pattern
  attr_accessor :nd_key, :nd_reference, :nd_collection
  attr_accessor :nd_stmts, :nd_args, :nd_requireds, :nd_optionals, :nd_keywords, :nd_elements, :nd_parts
  attr_accessor :nd_conditions, :nd_exceptions, :nd_targets, :nd_rights, :nd_posts, :nd_new_name, :nd_old_name, :nd_names
  attr_accessor :nd_unescaped
  attr_accessor :files

  def initialize
    @root_id = -1
    @source_file_path = ""
    @files = {}
    
    @nd_type = []
    @nd_name = []
    @nd_value = []
    @nd_content = []
    @nd_flags = []
    @nd_operator = []
    @nd_binop = []
    @nd_callop = []
    @nd_receiver = []
    @nd_arguments = []
    @nd_body = []
    @nd_block = []
    @nd_parameters = []
    @nd_predicate = []
    @nd_subsequent = []
    @nd_else_clause = []
    @nd_left = []
    @nd_right = []
    @nd_constant_path = []
    @nd_superclass = []
    @nd_rest = []
    @nd_keyword_rest = []
    @nd_rescue_clause = []
    @nd_ensure_clause = []
    @nd_expression = []
    @nd_target = []
    @nd_pattern = []
    @nd_key = []
    @nd_reference = []
    @nd_collection = []
    
    @nd_stmts = []
    @nd_args = []
    @nd_requireds = []
    @nd_optionals = []
    @nd_keywords = []
    @nd_elements = []
    @nd_parts = []
    @nd_conditions = []
    @nd_exceptions = []
    @nd_targets = []
    @nd_rights = []
    @nd_posts = []
    @nd_new_name = []
    @nd_old_name = []
    @nd_names = []
    @nd_unescaped = []
  end

  def set_root_id(val)
    @root_id = val
  end

  def set_source_file_path(val)
    @source_file_path = val
  end

  def set_file_entry(id, path)
    @files[id] = path
  end

  def alloc_nodes(count)
    while @nd_type.length < count
      @nd_type.push("")
      @nd_name.push("")
      @nd_value.push(0)
      @nd_content.push("")
      @nd_flags.push(0)
      @nd_operator.push("")
      @nd_binop.push("")
      @nd_callop.push("")
      @nd_receiver.push(-1)
      @nd_arguments.push(-1)
      @nd_body.push(-1)
      @nd_block.push(-1)
      @nd_parameters.push(-1)
      @nd_predicate.push(-1)
      @nd_subsequent.push(-1)
      @nd_else_clause.push(-1)
      @nd_left.push(-1)
      @nd_right.push(-1)
      @nd_constant_path.push(-1)
      @nd_superclass.push(-1)
      @nd_rest.push(-1)
      @nd_keyword_rest.push(-1)
      @nd_rescue_clause.push(-1)
      @nd_ensure_clause.push(-1)
      @nd_expression.push(-1)
      @nd_target.push(-1)
      @nd_pattern.push(-1)
      @nd_key.push(-1)
      @nd_reference.push(-1)
      @nd_collection.push(-1)
      
      @nd_stmts.push("")
      @nd_args.push("")
      @nd_requireds.push("")
      @nd_optionals.push("")
      @nd_keywords.push("")
      @nd_elements.push("")
      @nd_parts.push("")
      @nd_conditions.push("")
      @nd_exceptions.push("")
      @nd_targets.push("")
      @nd_rights.push("")
      @nd_posts.push("")
      @nd_new_name.push(-1)
      @nd_old_name.push(-1)
      @nd_names.push("")
      @nd_unescaped.push("")
    end
  end

  def set_node_type(nid, type)
    @nd_type[nid] = type
  end

  def set_node_content(nid, val)
    @nd_content[nid] = val
  end

  def set_string_field(nid, field, val)
    case field
    when "name"
      @nd_name[nid] = val
    when "content", "value", "kind"
      @nd_content[nid] = val
    when "operator"
      @nd_operator[nid] = val
    when "binary_operator"
      @nd_binop[nid] = val
    when "call_operator"
      @nd_callop[nid] = val
    when "names"
      @nd_names[nid] = val
    when "unescaped"
      @nd_unescaped[nid] = val
    end
  end

  def set_int_field(nid, field, val)
    case field
    when "value"
      @nd_value[nid] = val
    when "flags"
      @nd_flags[nid] = val
    end
  end

  def set_ref_field(nid, field, ref_id)
    case field
    when "receiver", "parent", "call"
      @nd_receiver[nid] = ref_id
    when "arguments"
      @nd_arguments[nid] = ref_id
    when "body", "statements"
      @nd_body[nid] = ref_id
    when "block"
      @nd_block[nid] = ref_id
    when "parameters"
      @nd_parameters[nid] = ref_id
    when "predicate"
      @nd_predicate[nid] = ref_id
    when "subsequent"
      @nd_subsequent[nid] = ref_id
    when "else_clause", "rescue_expression"
      @nd_else_clause[nid] = ref_id
    when "left"
      @nd_left[nid] = ref_id
    when "right"
      @nd_right[nid] = ref_id
    when "constant_path"
      @nd_constant_path[nid] = ref_id
    when "superclass"
      @nd_superclass[nid] = ref_id
    when "rest"
      @nd_rest[nid] = ref_id
    when "keyword_rest"
      @nd_keyword_rest[nid] = ref_id
    when "rescue_clause"
      @nd_rescue_clause[nid] = ref_id
    when "ensure_clause"
      @nd_ensure_clause[nid] = ref_id
    when "expression", "value", "numeric"
      @nd_expression[nid] = ref_id
    when "target", "index"
      @nd_target[nid] = ref_id
    when "pattern"
      @nd_pattern[nid] = ref_id
    when "key"
      @nd_key[nid] = ref_id
    when "reference"
      @nd_reference[nid] = ref_id
    when "collection"
      @nd_collection[nid] = ref_id
    when "new_name"
      @nd_new_name[nid] = ref_id
    when "old_name"
      @nd_old_name[nid] = ref_id
    end
  end

  def set_array_field(nid, field, ids_str)
    case field
    when "body"
      @nd_stmts[nid] = ids_str
    when "arguments"
      @nd_args[nid] = ids_str
    when "requireds"
      @nd_requireds[nid] = ids_str
    when "optionals"
      @nd_optionals[nid] = ids_str
    when "keywords"
      @nd_keywords[nid] = ids_str
    when "elements"
      @nd_elements[nid] = ids_str
    when "parts"
      @nd_parts[nid] = ids_str
    when "conditions"
      @nd_conditions[nid] = ids_str
    when "exceptions"
      @nd_exceptions[nid] = ids_str
    when "targets"
      @nd_targets[nid] = ids_str
    when "rights"
      @nd_rights[nid] = ids_str
    when "posts"
      @nd_posts[nid] = ids_str
    end
  end

  def escape_str(s)
    result = ""
    i = 0
    while i < s.length
      c = s[i]
      if c == "%"
        result += "%25"
      elsif c == "\n"
        result += "%0A"
      elsif c == "\r"
        result += "%0D"
      elsif c == "\t"
        result += "%09"
      elsif c == " "
        result += "%20"
      elsif c == "\0"
        result += "%00"
      else
        result += c
      end
      i += 1
    end
    result
  end

  def dump_text_ast
    out = []
    out.push("ROOT #{@root_id}")
    out.push("SOURCE_FILE #{escape_str(@source_file_path)}") if @source_file_path != ""
    
    @files.each do |id, path|
      out.push("FILE #{id} #{escape_str(path)}")
    end
    
    @nd_type.length.times do |nid|
      type = @nd_type[nid]
      next if type == "" || type.nil?
      
      out.push("N #{nid} #{type}")
      
      out.push("S #{nid} name #{escape_str(@nd_name[nid])}") if @nd_name[nid] != ""
      out.push("S #{nid} content #{escape_str(@nd_content[nid])}") if @nd_content[nid] != "" && type != "FloatNode"
      out.push("S #{nid} operator #{escape_str(@nd_operator[nid])}") if @nd_operator[nid] != ""
      out.push("S #{nid} binary_operator #{escape_str(@nd_binop[nid])}") if @nd_binop[nid] != ""
      out.push("S #{nid} call_operator #{escape_str(@nd_callop[nid])}") if @nd_callop[nid] != ""
      out.push("S #{nid} names #{escape_str(@nd_names[nid])}") if @nd_names[nid] != ""
      out.push("S #{nid} unescaped #{escape_str(@nd_unescaped[nid])}") if @nd_unescaped[nid] != ""
      
      out.push("I #{nid} value #{@nd_value[nid]}") if @nd_value[nid] != 0 && type == "IntegerNode"
      out.push("I #{nid} flags #{@nd_flags[nid]}") if @nd_flags[nid] != 0
      
      out.push("F #{nid} value #{@nd_content[nid]}") if type == "FloatNode"
      
      out.push("R #{nid} receiver #{@nd_receiver[nid]}") if @nd_receiver[nid] != -1
      out.push("R #{nid} arguments #{@nd_arguments[nid]}") if @nd_arguments[nid] != -1
      out.push("R #{nid} body #{@nd_body[nid]}") if @nd_body[nid] != -1
      out.push("R #{nid} block #{@nd_block[nid]}") if @nd_block[nid] != -1
      out.push("R #{nid} parameters #{@nd_parameters[nid]}") if @nd_parameters[nid] != -1
      out.push("R #{nid} predicate #{@nd_predicate[nid]}") if @nd_predicate[nid] != -1
      out.push("R #{nid} subsequent #{@nd_subsequent[nid]}") if @nd_subsequent[nid] != -1
      out.push("R #{nid} else_clause #{@nd_else_clause[nid]}") if @nd_else_clause[nid] != -1
      out.push("R #{nid} left #{@nd_left[nid]}") if @nd_left[nid] != -1
      out.push("R #{nid} right #{@nd_right[nid]}") if @nd_right[nid] != -1
      out.push("R #{nid} constant_path #{@nd_constant_path[nid]}") if @nd_constant_path[nid] != -1
      out.push("R #{nid} superclass #{@nd_superclass[nid]}") if @nd_superclass[nid] != -1
      out.push("R #{nid} rest #{@nd_rest[nid]}") if @nd_rest[nid] != -1
      out.push("R #{nid} keyword_rest #{@nd_keyword_rest[nid]}") if @nd_keyword_rest[nid] != -1
      out.push("R #{nid} rescue_clause #{@nd_rescue_clause[nid]}") if @nd_rescue_clause[nid] != -1
      out.push("R #{nid} ensure_clause #{@nd_ensure_clause[nid]}") if @nd_ensure_clause[nid] != -1
      out.push("R #{nid} expression #{@nd_expression[nid]}") if @nd_expression[nid] != -1
      out.push("R #{nid} target #{@nd_target[nid]}") if @nd_target[nid] != -1
      out.push("R #{nid} pattern #{@nd_pattern[nid]}") if @nd_pattern[nid] != -1
      out.push("R #{nid} key #{@nd_key[nid]}") if @nd_key[nid] != -1
      out.push("R #{nid} reference #{@nd_reference[nid]}") if @nd_reference[nid] != -1
      out.push("R #{nid} collection #{@nd_collection[nid]}") if @nd_collection[nid] != -1
      out.push("R #{nid} new_name #{@nd_new_name[nid]}") if @nd_new_name[nid] != -1
      out.push("R #{nid} old_name #{@nd_old_name[nid]}") if @nd_old_name[nid] != -1
      
      out.push("A #{nid} body #{@nd_stmts[nid]}") if @nd_stmts[nid] != ""
      out.push("A #{nid} arguments #{@nd_args[nid]}") if @nd_args[nid] != ""
      out.push("A #{nid} requireds #{@nd_requireds[nid]}") if @nd_requireds[nid] != ""
      out.push("A #{nid} optionals #{@nd_optionals[nid]}") if @nd_optionals[nid] != ""
      out.push("A #{nid} keywords #{@nd_keywords[nid]}") if @nd_keywords[nid] != ""
      out.push("A #{nid} elements #{@nd_elements[nid]}") if @nd_elements[nid] != ""
      out.push("A #{nid} parts #{@nd_parts[nid]}") if @nd_parts[nid] != ""
      out.push("A #{nid} conditions #{@nd_conditions[nid]}") if @nd_conditions[nid] != ""
      out.push("A #{nid} exceptions #{@nd_exceptions[nid]}") if @nd_exceptions[nid] != ""
      out.push("A #{nid} targets #{@nd_targets[nid]}") if @nd_targets[nid] != ""
      out.push("A #{nid} rights #{@nd_rights[nid]}") if @nd_rights[nid] != ""
      out.push("A #{nid} posts #{@nd_posts[nid]}") if @nd_posts[nid] != ""
    end
    out.join("\n") + "\n"
  end
end

class Macronel
  class << self
    def ast_table
      @ast_table
    end
    def ast_table=(val)
      @ast_table = val
    end
    
    def cc_cmd
      @cc_cmd
    end
    
    def cc_cmd=(val)
      @cc_cmd = val
    end
    
    def opt_level
      @opt_level
    end
    
    def opt_level=(val)
      @opt_level = val
    end

    # Helper API to query node attributes
    def node_type(nid)
      @ast_table.nd_type[nid]
    end

    def node_name(nid)
      @ast_table.nd_name[nid]
    end

    def node_value(nid)
      @ast_table.nd_value[nid]
    end

    def node_content(nid)
      return "" if nid < 0 || nid.nil?
      type = @ast_table.nd_type[nid]
      if type == "StringNode"
        @ast_table.nd_content[nid]
      elsif type == "InterpolatedStringNode"
        parts = parse_id_list(@ast_table.nd_parts[nid])
        res = ""
        i = 0
        while i < parts.length
          res << node_content(parts[i].to_i).to_s
          i = i + 1
        end
        res
      else
        @ast_table.nd_content[nid]
      end
    end

    def node_receiver(nid)
      @ast_table.nd_receiver[nid]
    end

    def node_arguments(nid)
      @ast_table.nd_arguments[nid]
    end

    def node_body(nid)
      @ast_table.nd_body[nid]
    end

    def node_block(nid)
      @ast_table.nd_block[nid]
    end

    def parse_id_list(list_str)
      return [] if list_str == "" || list_str.nil?
      res = []
      current = ""
      i = 0
      while i < list_str.length
        c = list_str[i].to_s
        if c == ","
          res.push(current.to_i)
          current = ""
        else
          current << c
        end
        i = i + 1
      end
      res.push(current.to_i) if current != ""
      res
    end

    def get_stmts(nid)
      return [] if nid < 0
      if @ast_table.nd_type[nid] == "StatementsNode"
        return parse_id_list(@ast_table.nd_stmts[nid])
      end
      body = @ast_table.nd_body[nid]
      return [] if body < 0
      parse_id_list(@ast_table.nd_stmts[body])
    end

    def get_args(nid)
      return [] if nid < 0
      if @ast_table.nd_type[nid] == "ArgumentsNode"
        return parse_id_list(@ast_table.nd_args[nid])
      end
      [nid]
    end

    def get_elements(nid)
      return [] if nid < 0
      parse_id_list(@ast_table.nd_elements[nid])
    end

    def escape_inspect(s)
      s = s.to_s
      res = "\""
      i = 0
      while i < s.length
        c = s[i].to_s
        if c == "\""
          res << "\\\""
        elsif c == "\\"
          res << "\\\\"
        elsif c == "\n"
          res << "\\n"
        elsif c == "\r"
          res << "\\r"
        elsif c == "\t"
          res << "\\t"
        else
          res << c
        end
        i = i + 1
      end
      res << "\""
      res.to_s
    end

    def to_ruby(nid)
      return "" if nid < 0 || nid.nil?
      
      type = @ast_table.nd_type[nid].to_s
      return "" if type == "" || type.nil?
      
      if type == "ProgramNode"
        return to_ruby(@ast_table.nd_body[nid]).to_s
      elsif type == "StatementsNode"
        stmts = parse_id_list(@ast_table.nd_stmts[nid])
        stmts_res = ""
        i = 0
        while i < stmts.length
          stmts_res << to_ruby(stmts[i].to_i).to_s
          stmts_res << "\n" if i < stmts.length - 1
          i = i + 1
        end
        return stmts_res.to_s
      elsif type == "IntegerNode"
        return @ast_table.nd_value[nid].to_s
      elsif type == "FloatNode"
        return @ast_table.nd_content[nid].to_s
      elsif type == "StringNode"
        return escape_inspect(@ast_table.nd_content[nid]).to_s
      elsif type == "SymbolNode"
        content = @ast_table.nd_content[nid].to_s
        if (content =~ /\A[a-zA-Z_][a-zA-Z0-9_]*[!?]?\z/) != nil || content == "+" || content == "-" || content == "*" || content == "/" || content == "<" || content == ">" || content == "<=" || content == ">=" || content == "=="
          return ":" + content.to_s
        else
          return ":" + escape_inspect(content).to_s
        end
      elsif type == "TrueNode"
        return "true"
      elsif type == "FalseNode"
        return "false"
      elsif type == "NilNode"
        return "nil"
      elsif type == "SelfNode"
        return "self"
      elsif type == "LocalVariableReadNode" || type == "InstanceVariableReadNode" || type == "ClassVariableReadNode" || type == "GlobalVariableReadNode" || type == "ConstantReadNode"
        return @ast_table.nd_name[nid].to_s
      elsif type == "LocalVariableWriteNode" || type == "InstanceVariableWriteNode" || type == "ClassVariableWriteNode" || type == "GlobalVariableWriteNode" || type == "ConstantWriteNode"
        write_res = ""
        write_res << @ast_table.nd_name[nid].to_s
        write_res << " = "
        write_res << to_ruby(@ast_table.nd_expression[nid]).to_s
        return write_res.to_s
      elsif type == "CallNode"
        recv = @ast_table.nd_receiver[nid]
        name = @ast_table.nd_name[nid].to_s
        args_id = @ast_table.nd_arguments[nid]
        args = []
        if args_id != -1
          args = get_args(args_id)
        end
        block_id = @ast_table.nd_block[nid]
        
        # Operators check
        if recv != -1 && args.length == 1 && (name == "+" || name == "-" || name == "*" || name == "/" || name == "==" || name == "!=" || name == "<" || name == ">" || name == "<=" || name == ">=")
          call_res = ""
          call_res << "("
          call_res << to_ruby(recv).to_s
          call_res << " "
          call_res << name
          call_res << " "
          call_res << to_ruby(args[0].to_i).to_s
          call_res << ")"
          return call_res.to_s
        elsif recv != -1 && args.length == 0 && name == "!"
          not_res = ""
          not_res << "!"
          not_res << to_ruby(recv).to_s
          return not_res.to_s
        else
          call_str = ""
          if recv != -1
            call_str << to_ruby(recv).to_s
            call_str << "."
            call_str << name
          else
            call_str << name
          end
          
          # Arguments
          if !args.empty? || recv == -1
            call_str << "("
            i = 0
            while i < args.length
              call_str << to_ruby(args[i].to_i).to_s
              call_str << ", " if i < args.length - 1
              i = i + 1
            end
            call_str << ")"
          end
          
          # Block
          if block_id != -1
            call_str << " "
            call_str << to_ruby(block_id).to_s
          end
          return call_str.to_s
        end
      elsif type == "BlockNode"
        params_id = @ast_table.nd_parameters[nid]
        body_id = @ast_table.nd_body[nid]
        param_str = ""
        if params_id != -1
          param_str << " |" << to_ruby(params_id).to_s << "|"
        end
        block_res = ""
        block_res << "do"
        block_res << param_str.to_s
        block_res << "\n"
        block_res << to_ruby(body_id).to_s
        block_res << "\nend"
        return block_res.to_s
      elsif type == "BlockParametersNode"
        return to_ruby(@ast_table.nd_parameters[nid]).to_s
      elsif type == "ParametersNode"
        reqs = parse_id_list(@ast_table.nd_requireds[nid])
        params_res = ""
        i = 0
        while i < reqs.length
          params_res << to_ruby(reqs[i].to_i).to_s
          params_res << ", " if i < reqs.length - 1
          i = i + 1
        end
        return params_res.to_s
      elsif type == "RequiredParameterNode"
        return @ast_table.nd_name[nid].to_s
      elsif type == "IfNode"
        pred = @ast_table.nd_predicate[nid]
        body = @ast_table.nd_body[nid]
        sub = @ast_table.nd_subsequent[nid]
        if_res = ""
        if_res << "if "
        if_res << to_ruby(pred).to_s
        if_res << "\n"
        if_res << to_ruby(body).to_s
        if sub != -1
          if_res << "\nelse\n"
          if_res << to_ruby(sub).to_s
        end
        if_res << "\nend"
        return if_res.to_s
      elsif type == "UnlessNode"
        pred = @ast_table.nd_predicate[nid]
        body = @ast_table.nd_body[nid]
        unless_res = ""
        unless_res << "unless "
        unless_res << to_ruby(pred).to_s
        unless_res << "\n"
        unless_res << to_ruby(body).to_s
        unless_res << "\nend"
        return unless_res.to_s
      elsif type == "WhileNode"
        pred = @ast_table.nd_predicate[nid]
        body = @ast_table.nd_body[nid]
        while_res = ""
        while_res << "while "
        while_res << to_ruby(pred).to_s
        while_res << "\n"
        while_res << to_ruby(body).to_s
        while_res << "\nend"
        return while_res.to_s
      elsif type == "ArgumentsNode"
        args = parse_id_list(@ast_table.nd_args[nid])
        args_res = ""
        i = 0
        while i < args.length
          args_res << to_ruby(args[i].to_i).to_s
          args_res << ", " if i < args.length - 1
          i = i + 1
        end
        return args_res.to_s
      elsif type == "ArrayNode"
        elems = get_elements(nid)
        array_res = "["
        i = 0
        while i < elems.length
          array_res << to_ruby(elems[i].to_i).to_s
          array_res << ", " if i < elems.length - 1
          i = i + 1
        end
        array_res << "]"
        return array_res.to_s
      elsif type == "HashNode"
        elems = get_elements(nid)
        hash_res = "{"
        i = 0
        while i < elems.length
          hash_res << to_ruby(elems[i].to_i).to_s
          hash_res << ", " if i < elems.length - 1
          i = i + 1
        end
        hash_res << "}"
        return hash_res.to_s
      elsif type == "AssocNode"
        assoc_res = ""
        assoc_res << to_ruby(@ast_table.nd_key[nid]).to_s
        assoc_res << " => "
        assoc_res << to_ruby(@ast_table.nd_expression[nid]).to_s
        return assoc_res.to_s
      elsif type == "ModuleNode"
        module_res = ""
        module_res << "module "
        module_res << to_ruby(@ast_table.nd_constant_path[nid]).to_s
        module_res << "\n"
        module_res << to_ruby(@ast_table.nd_body[nid]).to_s
        module_res << "\nend"
        return module_res.to_s
      elsif type == "ClassNode"
        class_res = ""
        class_res << "class "
        class_res << to_ruby(@ast_table.nd_constant_path[nid]).to_s
        superclass = @ast_table.nd_superclass[nid]
        if superclass != -1
          class_res << " < "
          class_res << to_ruby(superclass).to_s
        end
        class_res << "\n"
        class_res << to_ruby(@ast_table.nd_body[nid]).to_s
        class_res << "\nend"
        return class_res.to_s
      elsif type == "DefNode"
        recv = @ast_table.nd_receiver[nid]
        name = @ast_table.nd_name[nid].to_s
        params = @ast_table.nd_parameters[nid]
        body = @ast_table.nd_body[nid]
        def_str = "def "
        if recv != -1
          def_str << to_ruby(recv).to_s
          def_str << "."
        end
        def_str << name
        if params != -1
          def_str << "("
          def_str << to_ruby(params).to_s
          def_str << ")"
        end
        def_str << "\n"
        def_str << to_ruby(body).to_s
        def_str << "\nend"
        return def_str.to_s
      elsif type == "ConstantPathNode"
        parent = @ast_table.nd_receiver[nid]
        name = @ast_table.nd_name[nid].to_s
        cpath_res = ""
        if parent != -1
          cpath_res << to_ruby(parent).to_s
          cpath_res << "::"
        end
        cpath_res << name
        return cpath_res.to_s
      elsif type == "CaseNode"
        pred = @ast_table.nd_predicate[nid]
        conds = parse_id_list(@ast_table.nd_conditions[nid])
        else_cl = @ast_table.nd_else_clause[nid]
        case_res = ""
        case_res << "case "
        case_res << to_ruby(pred).to_s
        case_res << "\n"
        i = 0
        while i < conds.length
          case_res << to_ruby(conds[i].to_i).to_s
          case_res << "\n"
          i = i + 1
        end
        if else_cl != -1
          case_res << "else\n"
          case_res << to_ruby(else_cl).to_s
          case_res << "\n"
        end
        case_res << "end"
        return case_res.to_s
      elsif type == "WhenNode"
        conds = parse_id_list(@ast_table.nd_conditions[nid])
        body = @ast_table.nd_body[nid]
        when_res = "when "
        i = 0
        while i < conds.length
          when_res << to_ruby(conds[i].to_i).to_s
          when_res << ", " if i < conds.length - 1
          i = i + 1
        end
        when_res << "\n"
        when_res << to_ruby(body).to_s
        return when_res.to_s
      elsif type == "ElseNode"
        return to_ruby(@ast_table.nd_body[nid]).to_s
      elsif type == "ReturnNode"
        return_res = ""
        return_res << "return "
        return_res << to_ruby(@ast_table.nd_arguments[nid]).to_s
        return return_res.to_s
      elsif type == "OrNode"
        or_res = " ("
        or_res << to_ruby(@ast_table.nd_left[nid]).to_s
        or_res << " || "
        or_res << to_ruby(@ast_table.nd_right[nid]).to_s
        or_res << ") "
        return or_res.to_s
      elsif type == "AndNode"
        and_res = " ("
        and_res << to_ruby(@ast_table.nd_left[nid]).to_s
        and_res << " && "
        and_res << to_ruby(@ast_table.nd_right[nid]).to_s
        and_res << ") "
        return and_res.to_s
      elsif type == "LocalVariableOperatorWriteNode" || type == "InstanceVariableOperatorWriteNode"
        opwrite_res = ""
        opwrite_res << @ast_table.nd_name[nid].to_s
        opwrite_res << " "
        opwrite_res << @ast_table.nd_binop[nid].to_s
        opwrite_res << "= "
        opwrite_res << to_ruby(@ast_table.nd_expression[nid]).to_s
        return opwrite_res.to_s
      elsif type == "LocalVariableOrWriteNode" || type == "InstanceVariableOrWriteNode"
        orwrite_res = ""
        orwrite_res << @ast_table.nd_name[nid].to_s
        orwrite_res << " ||= "
        orwrite_res << to_ruby(@ast_table.nd_expression[nid]).to_s
        return orwrite_res.to_s
      elsif type == "LocalVariableAndWriteNode" || type == "InstanceVariableAndWriteNode"
        andwrite_res = ""
        andwrite_res << @ast_table.nd_name[nid].to_s
        andwrite_res << " &&= "
        andwrite_res << to_ruby(@ast_table.nd_expression[nid]).to_s
        return andwrite_res.to_s
      elsif type == "NextNode"
        return "next"
      elsif type == "RangeNode"
        left = @ast_table.nd_left[nid]
        right = @ast_table.nd_right[nid]
        exclude_end = (@ast_table.nd_flags[nid].to_i & 4) != 0
        dot_str = exclude_end ? "..." : ".."
        range_res = " ("
        range_res << to_ruby(left).to_s
        range_res << dot_str
        range_res << to_ruby(right).to_s
        range_res << ") "
        return range_res.to_s
      elsif type == "RegularExpressionNode"
        regexp_res = "/"
        regexp_res << @ast_table.nd_unescaped[nid].to_s
        regexp_res << "/"
        return regexp_res.to_s
      elsif type == "InterpolatedStringNode"
        parts = parse_id_list(@ast_table.nd_parts[nid])
        istring_res = "\""
        i = 0
        while i < parts.length
          p = parts[i].to_i
          if @ast_table.nd_type[p].to_s == "StringNode"
            istring_res << @ast_table.nd_content[p].to_s
          else
            istring_res << to_ruby(p).to_s
          end
          i = i + 1
        end
        istring_res << "\""
        return istring_res.to_s
      elsif type == "InterpolatedRegularExpressionNode"
        parts = parse_id_list(@ast_table.nd_parts[nid])
        iregexp_res = "/"
        i = 0
        while i < parts.length
          p = parts[i].to_i
          if @ast_table.nd_type[p].to_s == "StringNode"
            iregexp_res << @ast_table.nd_content[p].to_s
          else
            iregexp_res << to_ruby(p).to_s
          end
          i = i + 1
        end
        iregexp_res << "/"
        return iregexp_res.to_s
      elsif type == "InterpolatedXStringNode"
        parts = parse_id_list(@ast_table.nd_parts[nid])
        ixstring_res = "`"
        i = 0
        while i < parts.length
          p = parts[i].to_i
          if @ast_table.nd_type[p].to_s == "StringNode"
            ixstring_res << @ast_table.nd_content[p].to_s
          else
            ixstring_res << to_ruby(p).to_s
          end
          i = i + 1
        end
        ixstring_res << "`"
        return ixstring_res.to_s
      elsif type == "XStringNode"
        xstring_res = "`"
        xstring_res << @ast_table.nd_content[nid].to_s
        xstring_res << "`"
        return xstring_res.to_s
      elsif type == "EmbeddedStatementsNode"
        embedded_res = "\#{"
        embedded_res << to_ruby(@ast_table.nd_body[nid]).to_s
        embedded_res << "}"
        return embedded_res.to_s
      elsif type == "ParenthesesNode"
        paren_res = "("
        paren_res << to_ruby(@ast_table.nd_body[nid]).to_s
        paren_res << ")"
        return paren_res.to_s
      else
        else_res = "#<Unhandled node type: "
        else_res << type << " id: " << nid.to_s << ">"
        return else_res.to_s
      end
    end

    def remove_node_list(list_str)
      list_str = list_str.to_s
      return if list_str == ""
      parts = list_str.split(",")
      i = 0
      while i < parts.length
        remove_node_tree(parts[i].to_i)
        i = i + 1
      end
    end

    def remove_node_tree(nid)
      return if nid < 0 || nid.nil?
      type = @ast_table.nd_type[nid].to_s
      return if type == ""
      
      @ast_table.nd_type[nid] = ""
      
      remove_node_tree(@ast_table.nd_receiver[nid])
      remove_node_tree(@ast_table.nd_arguments[nid])
      remove_node_tree(@ast_table.nd_body[nid])
      remove_node_tree(@ast_table.nd_block[nid])
      remove_node_tree(@ast_table.nd_parameters[nid])
      remove_node_tree(@ast_table.nd_predicate[nid])
      remove_node_tree(@ast_table.nd_subsequent[nid])
      remove_node_tree(@ast_table.nd_else_clause[nid])
      remove_node_tree(@ast_table.nd_left[nid])
      remove_node_tree(@ast_table.nd_right[nid])
      remove_node_tree(@ast_table.nd_constant_path[nid])
      remove_node_tree(@ast_table.nd_superclass[nid])
      remove_node_tree(@ast_table.nd_rest[nid])
      remove_node_tree(@ast_table.nd_keyword_rest[nid])
      remove_node_tree(@ast_table.nd_rescue_clause[nid])
      remove_node_tree(@ast_table.nd_ensure_clause[nid])
      remove_node_tree(@ast_table.nd_expression[nid])
      remove_node_tree(@ast_table.nd_target[nid])
      remove_node_tree(@ast_table.nd_pattern[nid])
      remove_node_tree(@ast_table.nd_key[nid])
      remove_node_tree(@ast_table.nd_reference[nid])
      remove_node_tree(@ast_table.nd_collection[nid])
      remove_node_tree(@ast_table.nd_new_name[nid])
      remove_node_tree(@ast_table.nd_old_name[nid])
      
      remove_node_list(@ast_table.nd_stmts[nid])
      remove_node_list(@ast_table.nd_args[nid])
      remove_node_list(@ast_table.nd_requireds[nid])
      remove_node_list(@ast_table.nd_optionals[nid])
      remove_node_list(@ast_table.nd_keywords[nid])
      remove_node_list(@ast_table.nd_elements[nid])
      remove_node_list(@ast_table.nd_parts[nid])
      remove_node_list(@ast_table.nd_conditions[nid])
      remove_node_list(@ast_table.nd_exceptions[nid])
      remove_node_list(@ast_table.nd_targets[nid])
      remove_node_list(@ast_table.nd_rights[nid])
      remove_node_list(@ast_table.nd_posts[nid])
    end

    # Walk the AST to find macro registrations and perform expansions
    def expand_macros(ast_file)
      table = MacronelTable.new
      loader = NodeTableLoader.new(table)
      loader.read_text_ast(File.read(ast_file))
      @ast_table = table



      # 1. Find module MacronelMacros
      macronel_module_id = -1
      table.nd_type.length.times do |nid|
        if table.nd_type[nid] == "ModuleNode"
          cpath = table.nd_constant_path[nid]
          if cpath != -1 && table.nd_name[cpath] == "MacronelMacros"
            macronel_module_id = nid
            break
          end
        end
      end



      return if macronel_module_id == -1

      # 2. Extract macros registered in MacronelMacros
      body_id = table.nd_body[macronel_module_id]

      return if body_id == -1

      registered_macros = []
      stmts = get_stmts(body_id)
      i = 0
      while i < stmts.length
        nid = stmts[i].to_i
        if table.nd_type[nid] == "CallNode" && table.nd_name[nid] == "register_macro"
          args_id = table.nd_arguments[nid]
          if args_id != -1
            args = get_args(args_id)
            if !args.empty?
              arg_node = args[0]
              registered_macros.push(table.nd_content[arg_node])
            end
          end
        end
        i = i + 1
      end

      return if registered_macros.empty?

      # Extract arities of registered macros from the AST (Do this BEFORE modifying the AST or deleting the module)
      macro_arities = {}
      i = 0
      while i < registered_macros.length
        m = registered_macros[i].to_s
        arity = 0
        nid = 0
        while nid < table.nd_type.length
          if table.nd_type[nid] == "DefNode" && table.nd_name[nid] == m
            recv = table.nd_receiver[nid]
            if recv != -1 && table.nd_type[recv] == "SelfNode"
              params_id = table.nd_parameters[nid]
              arity = get_parameter_count(table, params_id)
              break
            end
          end
          nid = nid + 1
        end
        macro_arities[m] = arity
        i = i + 1
      end

      # Get the Ruby code of LispNode (if defined at top-level)
      lisp_node_id = -1
      nid = 0
      while nid < table.nd_type.length
        if table.nd_type[nid] == "ClassNode"
          cpath = table.nd_constant_path[nid]
          if cpath != -1 && table.nd_name[cpath] == "LispNode"
            lisp_node_id = nid
            break
          end
        end
        nid = nid + 1
      end
      
      lisp_node_code = ""
      if lisp_node_id != -1
        lisp_node_code = to_ruby(lisp_node_id).to_s
      end

      # Get the Ruby code of module MacronelMacros
      module_code = to_ruby(macronel_module_id)

      root_stmts = get_stmts(table.root_id)
      new_root_stmts = []
      i = 0
      while i < root_stmts.length
        id = root_stmts[i].to_i
        keep = true
        if id == macronel_module_id
          remove_node_tree(id)
          keep = false
        elsif id == lisp_node_id
          remove_node_tree(id)
          keep = false
        elsif table.nd_type[id] == "ModuleNode" && table.nd_constant_path[id] != -1 && table.nd_name[table.nd_constant_path[id]] == "Macronel"
          remove_node_tree(id)
          keep = false
        elsif table.nd_type[id] == "ClassNode" && table.nd_constant_path[id] != -1 && table.nd_name[table.nd_constant_path[id]] == "MacronelTable"
          remove_node_tree(id)
          keep = false
        end
        if keep
          new_root_stmts.push(id)
        end
        i = i + 1
      end
      
      new_root_stmts_str = ""
      i = 0
      while i < new_root_stmts.length
        new_root_stmts_str << new_root_stmts[i].to_s
        new_root_stmts_str << "," if i < new_root_stmts.length - 1
        i = i + 1
      end
      table.nd_stmts[table.root_id] = new_root_stmts_str.to_s

      # Write out the modified AST to a temporary file for the macro runner to read
      tmp_ast_file = ast_file + ".pre_macro"
      File.write(tmp_ast_file, table.dump_text_ast)

      # 3. Generate the macro runner script
      runner_code = <<~RUBY
        # macro_runner.rb - Automatically generated by Macronel
        require_relative 'node_table_loader'
        require_relative 'lib/macronel'

        # Real Macronel class is imported via require_relative 'lib/macronel'

        # Dummy definition of register_macro to prevent errors during execution
        module MacronelMacros
          def self.register_macro(name)
            # no-op
          end
        end

        # User's macro definitions:
        #{lisp_node_code}
        #{module_code}

        ast_file = ARGV[0]
        call_id = ARGV[1].to_i

        # Load current AST
        table = MacronelTable.new
        loader = NodeTableLoader.new(table)
        loader.read_text_ast(File.read(ast_file))
        Macronel.ast_table = table

        # Dispatch
        macro_name = table.nd_name[call_id]
        args_id = table.nd_arguments[call_id]
        args = args_id != -1 ? Macronel.get_args(args_id) : []
        block_id = table.nd_block[call_id]
        args.push(block_id) if block_id != -1

        result = ""
        case macro_name
      RUBY

      macro_idx = 0
      while macro_idx < registered_macros.length
        m = registered_macros[macro_idx].to_s
        arity = macro_arities[m].to_i
        call_str = ""
        i = 0
        while i < arity
          call_str << "args[" << i.to_s << "].to_i"
          call_str << ", " if i < arity - 1
          i = i + 1
        end

        runner_code << "when \"" << m.to_s << "\"\n"
        runner_code << "  result = MacronelMacros." << m.to_s << "(" << call_str.to_s << ")\n"
        macro_idx = macro_idx + 1
      end

      runner_code << <<~RUBY
        else
          $stderr.puts "Unknown macro: " + macro_name
          exit 1
        end

        print result
      RUBY

      runner_file = "macro_runner.rb"
      File.write(runner_file, runner_code.to_s)

      # Determine if we should compile or run interpreted
      run_compiled = false
      # Only compile macro runner if the full compiler toolchain is present
      has_parser = File.exist?("spinel_parse.exe") || File.exist?("spinel_parse")
      has_analyzer = File.exist?("spinel_analyze.exe") || File.exist?("spinel_analyze")
      has_codegen = File.exist?("spinel_codegen.exe") || File.exist?("spinel_codegen")
      if has_parser && has_analyzer && has_codegen
        run_compiled = true
      end

      if run_compiled
        puts "[Macronel] Compiling macro runner natively..."
        tmp_runner_ast = "tmp_macro_runner.ast"
        tmp_runner_ir = "tmp_macro_runner.ir"
        tmp_runner_c = "tmp_macro_runner.c"
        
        Macronel.parse(runner_file, tmp_runner_ast)
        Macronel.analyze(tmp_runner_ast, tmp_runner_ir)
        Macronel.codegen(tmp_runner_ast, tmp_runner_ir, tmp_runner_c)
        
        runner_exe = bin_path("macro_runner")
        
        cc = Macronel.cc_cmd.to_s
        cc = "gcc" if cc == "" || cc.nil?
        opt = Macronel.opt_level.to_s
        opt = "2" if opt == "" || opt.nil?
        
        success_compile = Macronel.compile_c(tmp_runner_c, runner_exe, cc, opt)
        
        File.delete(tmp_runner_ast) if File.exist?(tmp_runner_ast)
        File.delete(tmp_runner_ir) if File.exist?(tmp_runner_ir)
        File.delete(tmp_runner_c) if File.exist?(tmp_runner_c)
        
        if !success_compile
          puts "[Macronel] Failed to compile macro runner, falling back to interpreted"
          run_compiled = false
        end
      end

      # 4. Find all macro calls in the user AST and expand them
      # We do a DFS traversal starting at the root
      loop do
        expanded_any = false
        
        # Reload AST to get clean state
        table = MacronelTable.new
        loader = NodeTableLoader.new(table)
        loader.read_text_ast(File.read(tmp_ast_file))
        @ast_table = table

        # Find first CallNode matching registered macro
        call_node_id = -1
        nid = 0
        while nid < table.nd_type.length
          if table.nd_type[nid] == "CallNode"
            name = table.nd_name[nid].to_s
            found = false
            rm_idx = 0
            while rm_idx < registered_macros.length
              if registered_macros[rm_idx].to_s == name
                found = true
                break
              end
              rm_idx = rm_idx + 1
            end
            if found
              call_node_id = nid
              break
            end
          end
          nid = nid + 1
        end

        break if call_node_id == -1

        # Run the macro runner
        cmd = ""
        if run_compiled
          runner_exe = bin_path("macro_runner")
          cmd = "#{runner_exe} #{tmp_ast_file} #{call_node_id}"
        else
          cmd = "ruby #{runner_file} #{tmp_ast_file} #{call_node_id} 2>&1"
        end

        output = `#{cmd}`
        
        # Parse the output Ruby code using spinel_parse
        # Write to a temp file and parse it
        tmp_macro_out = "macro_out.rb"
        File.write(tmp_macro_out, output)
        
        tmp_macro_ast = "macro_out.ast"
        # Run parser
        parse_bin = bin_path("spinel_parse")
        
        if !system("#{parse_bin} #{tmp_macro_out} #{tmp_macro_ast}")
          # Fallback to spinel_parse.rb if C binary not built
          system("ruby spinel_parse.rb #{tmp_macro_out} #{tmp_macro_ast}")
        end

        # Load parsed macro output AST
        macro_table = MacronelTable.new
        macro_loader = NodeTableLoader.new(macro_table)
        macro_loader.read_text_ast(File.read(tmp_macro_ast))

        # Clean up temporary files
        File.delete(tmp_macro_out) if File.exist?(tmp_macro_out)
        File.delete(tmp_macro_ast) if File.exist?(tmp_macro_ast)

        # Merge macro AST into the main AST.
        # We need to allocate new IDs in `table` for all nodes in `macro_table`
        # and replace the `call_node_id` with the root of `macro_table` AST.
        offset = table.nd_type.length
        table.alloc_nodes(offset + macro_table.nd_type.length)

        # Copy nodes with ID offset

        mnid = 0
        while mnid < macro_table.nd_type.length
          new_nid = offset + mnid
          table.nd_type[new_nid] = macro_table.nd_type[mnid]
          table.nd_name[new_nid] = macro_table.nd_name[mnid]
          table.nd_value[new_nid] = macro_table.nd_value[mnid]
          table.nd_content[new_nid] = macro_table.nd_content[mnid]
          table.nd_flags[new_nid] = macro_table.nd_flags[mnid]
          table.nd_operator[new_nid] = macro_table.nd_operator[mnid]
          table.nd_binop[new_nid] = macro_table.nd_binop[mnid]
          table.nd_callop[new_nid] = macro_table.nd_callop[mnid]
          table.nd_names[new_nid] = macro_table.nd_names[mnid]

          table.nd_receiver[new_nid] = offset_ref(macro_table.nd_receiver[mnid], offset)
          table.nd_arguments[new_nid] = offset_ref(macro_table.nd_arguments[mnid], offset)
          table.nd_body[new_nid] = offset_ref(macro_table.nd_body[mnid], offset)
          table.nd_block[new_nid] = offset_ref(macro_table.nd_block[mnid], offset)
          table.nd_parameters[new_nid] = offset_ref(macro_table.nd_parameters[mnid], offset)
          table.nd_predicate[new_nid] = offset_ref(macro_table.nd_predicate[mnid], offset)
          table.nd_subsequent[new_nid] = offset_ref(macro_table.nd_subsequent[mnid], offset)
          table.nd_else_clause[new_nid] = offset_ref(macro_table.nd_else_clause[mnid], offset)
          table.nd_left[new_nid] = offset_ref(macro_table.nd_left[mnid], offset)
          table.nd_right[new_nid] = offset_ref(macro_table.nd_right[mnid], offset)
          table.nd_constant_path[new_nid] = offset_ref(macro_table.nd_constant_path[mnid], offset)
          table.nd_superclass[new_nid] = offset_ref(macro_table.nd_superclass[mnid], offset)
          table.nd_rest[new_nid] = offset_ref(macro_table.nd_rest[mnid], offset)
          table.nd_keyword_rest[new_nid] = offset_ref(macro_table.nd_keyword_rest[mnid], offset)
          table.nd_rescue_clause[new_nid] = offset_ref(macro_table.nd_rescue_clause[mnid], offset)
          table.nd_ensure_clause[new_nid] = offset_ref(macro_table.nd_ensure_clause[mnid], offset)
          table.nd_expression[new_nid] = offset_ref(macro_table.nd_expression[mnid], offset)
          table.nd_target[new_nid] = offset_ref(macro_table.nd_target[mnid], offset)
          table.nd_pattern[new_nid] = offset_ref(macro_table.nd_pattern[mnid], offset)
          table.nd_key[new_nid] = offset_ref(macro_table.nd_key[mnid], offset)
          table.nd_reference[new_nid] = offset_ref(macro_table.nd_reference[mnid], offset)
          table.nd_collection[new_nid] = offset_ref(macro_table.nd_collection[mnid], offset)
          table.nd_new_name[new_nid] = offset_ref(macro_table.nd_new_name[mnid], offset)
          table.nd_old_name[new_nid] = offset_ref(macro_table.nd_old_name[mnid], offset)

          table.nd_stmts[new_nid] = offset_array_str(macro_table.nd_stmts[mnid], offset)
          table.nd_args[new_nid] = offset_array_str(macro_table.nd_args[mnid], offset)
          table.nd_requireds[new_nid] = offset_array_str(macro_table.nd_requireds[mnid], offset)
          table.nd_optionals[new_nid] = offset_array_str(macro_table.nd_optionals[mnid], offset)
          table.nd_keywords[new_nid] = offset_array_str(macro_table.nd_keywords[mnid], offset)
          table.nd_elements[new_nid] = offset_array_str(macro_table.nd_elements[mnid], offset)
          table.nd_parts[new_nid] = offset_array_str(macro_table.nd_parts[mnid], offset)
          table.nd_conditions[new_nid] = offset_array_str(macro_table.nd_conditions[mnid], offset)
          table.nd_exceptions[new_nid] = offset_array_str(macro_table.nd_exceptions[mnid], offset)
          table.nd_targets[new_nid] = offset_array_str(macro_table.nd_targets[mnid], offset)
          table.nd_rights[new_nid] = offset_array_str(macro_table.nd_rights[mnid], offset)
          table.nd_posts[new_nid] = offset_array_str(macro_table.nd_posts[mnid], offset)
          mnid = mnid + 1
        end


        # Now, replace the call_node_id in the main AST with the root of macro_table.
        # The root of the macro_table is at index 0, which corresponds to offset in table.
        macro_root_id = offset + macro_table.root_id
        if macro_table.nd_type[macro_table.root_id] == "ProgramNode"
          body_id = macro_table.nd_body[macro_table.root_id]
          if body_id != -1 && macro_table.nd_type[body_id] == "StatementsNode"
            stmts_str = macro_table.nd_stmts[body_id]
            if stmts_str != "" && !stmts_str.nil?
              stmts_arr = stmts_str.split(",")
              if stmts_arr.length == 1
                macro_root_id = offset + stmts_arr[0].to_i
              else
                macro_root_id = offset + body_id
              end
            end
          end
        end

        # Find the parent of call_node_id and replace the reference.
        # Parent can refer to child via ref field (nd_receiver, etc.) or list field (nd_stmts, etc.)

        pid = 0
        while pid < offset

          # Check refs
          if table.nd_receiver[pid] == call_node_id
            table.nd_receiver[pid] = macro_root_id
          elsif table.nd_arguments[pid] == call_node_id
            table.nd_arguments[pid] = macro_root_id
          elsif table.nd_body[pid] == call_node_id
            table.nd_body[pid] = macro_root_id
          elsif table.nd_block[pid] == call_node_id
            table.nd_block[pid] = macro_root_id
          elsif table.nd_parameters[pid] == call_node_id
            table.nd_parameters[pid] = macro_root_id
          elsif table.nd_predicate[pid] == call_node_id
            table.nd_predicate[pid] = macro_root_id
          elsif table.nd_subsequent[pid] == call_node_id
            table.nd_subsequent[pid] = macro_root_id
          elsif table.nd_else_clause[pid] == call_node_id
            table.nd_else_clause[pid] = macro_root_id
          elsif table.nd_left[pid] == call_node_id
            table.nd_left[pid] = macro_root_id
          elsif table.nd_right[pid] == call_node_id
            table.nd_right[pid] = macro_root_id
          elsif table.nd_constant_path[pid] == call_node_id
            table.nd_constant_path[pid] = macro_root_id
          elsif table.nd_superclass[pid] == call_node_id
            table.nd_superclass[pid] = macro_root_id
          elsif table.nd_expression[pid] == call_node_id
            table.nd_expression[pid] = macro_root_id
          elsif table.nd_target[pid] == call_node_id
            table.nd_target[pid] = macro_root_id
          elsif table.nd_pattern[pid] == call_node_id
            table.nd_pattern[pid] = macro_root_id
          elsif table.nd_key[pid] == call_node_id
            table.nd_key[pid] = macro_root_id
          elsif table.nd_reference[pid] == call_node_id
            table.nd_reference[pid] = macro_root_id
          elsif table.nd_collection[pid] == call_node_id
            table.nd_collection[pid] = macro_root_id
          end

          table.nd_stmts[pid] = replace_in_list_str(table.nd_stmts[pid], call_node_id, macro_root_id) if table.nd_stmts[pid] != ""
          table.nd_args[pid] = replace_in_list_str(table.nd_args[pid], call_node_id, macro_root_id) if table.nd_args[pid] != ""
          table.nd_elements[pid] = replace_in_list_str(table.nd_elements[pid], call_node_id, macro_root_id) if table.nd_elements[pid] != ""
          table.nd_parts[pid] = replace_in_list_str(table.nd_parts[pid], call_node_id, macro_root_id) if table.nd_parts[pid] != ""
          table.nd_conditions[pid] = replace_in_list_str(table.nd_conditions[pid], call_node_id, macro_root_id) if table.nd_conditions[pid] != ""
          table.nd_exceptions[pid] = replace_in_list_str(table.nd_exceptions[pid], call_node_id, macro_root_id) if table.nd_exceptions[pid] != ""
          pid = pid + 1
        end


        # Mark the replaced call node as deleted in the AST
        table.nd_type[call_node_id] = ""

        # Dump modified AST back
        File.write(tmp_ast_file, table.dump_text_ast)
        expanded_any = true
      end

      # Copy tmp_ast_file back to ast_file and clean up
      if File.exist?(tmp_ast_file)
        File.write(ast_file, File.read(tmp_ast_file))
        File.delete(tmp_ast_file)
      end
      
      File.delete(runner_file) if File.exist?(runner_file)
      runner_exe = bin_path("macro_runner")
      File.delete(runner_exe) if File.exist?(runner_exe)
    end

    def get_parameter_count(table, params_id)
      return 0 if params_id.to_i == -1
      
      ptype = table.nd_type[params_id.to_i].to_s
      if ptype == "ParametersNode"
        reqs = parse_id_list(table.nd_requireds[params_id.to_i])
        opts = parse_id_list(table.nd_optionals[params_id.to_i])
        return reqs.length + opts.length
      end
      0
    end

    def offset_ref(ref, offset)
      ref.to_i == -1 ? -1 : offset.to_i + ref.to_i
    end

    def offset_array_str(list_str, offset)
      list_str = list_str.to_s
      return "" if list_str == ""
      
      parts = list_str.split(",")
      res = ""
      i = 0
      while i < parts.length
        val = parts[i].to_i
        res << (offset.to_i + val).to_s
        res << "," if i < parts.length - 1
        i = i + 1
      end
      res.to_s
    end

    def replace_in_list_str(list_str, target_id, replacement_id)
      list_str = list_str.to_s
      return "" if list_str == ""
      
      parts = list_str.split(",")
      res = ""
      i = 0
      while i < parts.length
        val = parts[i].to_i
        if val == target_id.to_i
          res << replacement_id.to_s
        else
          res << val.to_s
        end
        res << "," if i < parts.length - 1
        i = i + 1
      end
      res.to_s
    end

    def bin_path(name)
      name = name.to_s
      prefix = "./"
      ext = ""
      if File.exist?("spinel_parse.exe")
        prefix = ""
        ext = ".exe"
      end
      res = ""
      res << prefix << name << ext
      res.to_s
    end

    def parse(src_file, ast_file)
      if File.exist?("spinel_parse.rb")
        system("ruby spinel_parse.rb #{src_file} #{ast_file}")
      else
        parse_bin = bin_path("spinel_parse")
        bin_file = "spinel_parse"
        if File.exist?("spinel_parse.exe")
          bin_file = "spinel_parse.exe"
        end
        
        if File.exist?(bin_file)
          system("#{parse_bin} #{src_file} #{ast_file}")
        else
          puts "Error: spinel_parse parser not found."
          exit 1
        end
      end
    end

    def analyze(ast_file, ir_file)
      analyze_bin = bin_path("spinel_analyze")
      bin_file = "spinel_analyze"
      if File.exist?("spinel_analyze.exe")
        bin_file = "spinel_analyze.exe"
      end

      if File.exist?(bin_file)
        system("#{analyze_bin} #{ast_file} #{ir_file}")
      else
        puts "Error: spinel_analyze binary not found. Please build it first."
        exit 1
      end
    end

    def codegen(ast_file, ir_file, c_file)
      codegen_bin = bin_path("spinel_codegen")
      bin_file = "spinel_codegen"
      if File.exist?("spinel_codegen.exe")
        bin_file = "spinel_codegen.exe"
      end

      if File.exist?(bin_file)
        system("#{codegen_bin} #{ast_file} #{ir_file} #{c_file}")
      else
        puts "Error: spinel_codegen binary not found. Please build it first."
        exit 1
      end
    end

    def compile_c(c_file, output_file, cc = "gcc", opt_level = "2")
      stack_flag = ""
      if RUBY_PLATFORM =~ /mingw|mswin/
        stack_flag = "-Wl,--stack,67108864"
      end
      
      # Setup environment PATH for MSYS2 UCRT64 gcc if needed
      old_path = nil
      if cc =~ /msys64/
        msys_base = cc.split("/ucrt64/").first.split("\\ucrt64\\").first
        ucrt_bin = File.join(msys_base, "ucrt64", "bin")
        msys_bin = File.join(msys_base, "usr", "bin")
        old_path = ENV['PATH']
        ENV['PATH'] = "#{ucrt_bin};#{msys_bin};#{old_path}"
      end
      
      extra_flags = ""
      rt_lib = "./lib/libspinel_rt.a"
      if File.exist?(rt_lib)
        extra_flags = " #{rt_lib}"
      end
      
      cmd = "#{cc} -O#{opt_level} -Wno-all -ffunction-sections -fdata-sections -I./lib #{c_file} -lm #{stack_flag} #{extra_flags} -o #{output_file}"
      success = system(cmd)
      
      # Restore PATH
      ENV['PATH'] = old_path if old_path
      success
    end
  end
end

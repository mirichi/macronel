# macronel_cruby.rb
# CLI driver for the Macronel compiler in CRuby (macro preprocessor & interpreter)

require_relative 'node_table_loader'
require_relative 'lib/macronel'

src_file = ""
output_file = ""
stdout_mode = false
run_mode = true

# Parse CLI arguments using simple index loop
i = 0
while i < ARGV.length
  arg = ARGV[i].to_s
  if arg == "-o"
    output_file = ARGV[i + 1].to_s
    run_mode = false
    i = i + 2
  elsif arg == "-S"
    stdout_mode = true
    run_mode = false
    i = i + 1
  elsif arg.length > 0 && arg[0..0] == "-"
    puts "Unknown option: " + arg
    puts "Macronel CRuby Runner"
    puts "Usage: ruby macronel_cruby.rb app.rb [options]"
    puts "Options:"
    puts "  -o FILE      Output the expanded Ruby source to FILE"
    puts "  -S           Print expanded Ruby source to stdout"
    exit 1
  else
    if src_file == ""
      src_file = arg
    else
      puts "Too many input files"
      exit 1
    end
    i = i + 1
  end
end

if src_file == ""
  puts "Macronel CRuby Runner"
  puts "Usage: ruby macronel_cruby.rb app.rb [options]"
  puts "Options:"
  puts "  -o FILE      Output the expanded Ruby source to FILE"
  puts "  -S           Print expanded Ruby source to stdout"
  exit 1
end

if !File.exist?(src_file)
  puts "macronel_cruby: " + src_file + ": No such file"
  exit 1
end

basename = File.basename(src_file).to_s.gsub(".rb", "")
tmp_ast = "tmp_" + basename + ".ast"

# Set compilation options on Macronel module
Macronel.cc_cmd = "gcc"
Macronel.opt_level = "2"

begin
  # Step 1: Parse to AST
  Macronel.parse(src_file, tmp_ast)

  # Step 2: Expand macros in the AST
  Macronel.expand_macros(tmp_ast)

  # Step 3: Load the expanded AST
  table = MacronelTable.new
  loader = NodeTableLoader.new(table)
  loader.read_text_ast(File.read(tmp_ast))
  Macronel.ast_table = table

  # Step 4: Reconstruct to Ruby code
  expanded_ruby = Macronel.to_ruby(table.root_id)

  # Step 5: Handle output mode
  if stdout_mode
    puts expanded_ruby
  elsif output_file != ""
    File.write(output_file, expanded_ruby)
  elsif run_mode
    # Execute the expanded ruby code using current ruby interpreter
    # We write it to a temporary ruby file and run it so that __FILE__ and stack traces make sense.
    tmp_ruby = "tmp_" + basename + "_expanded.rb"
    File.write(tmp_ruby, expanded_ruby)
    begin
      system("ruby #{tmp_ruby}")
    ensure
      File.delete(tmp_ruby) if File.exist?(tmp_ruby)
    end
  end

ensure
  # Clean up temporary AST
  File.delete(tmp_ast) if File.exist?(tmp_ast)
end

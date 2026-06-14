# macronel.rb
# CLI driver for the Macronel compiler in Spinel-compilable Ruby
require_relative 'lib/macronel'

src_file = ""
output_file = ""
c_only = false
stdout_mode = false
opt_level = "2"
cc_cmd = "gcc"

# Parse CLI arguments using simple index loop
i = 0
while i < ARGV.length
  arg = ARGV[i].to_s
  if arg == "-o"
    output_file = ARGV[i + 1].to_s
    i = i + 2
  elsif arg == "-c"
    c_only = true
    i = i + 1
  elsif arg == "-S"
    stdout_mode = true
    i = i + 1
  elsif arg == "-O"
    opt_level = ARGV[i + 1].to_s
    i = i + 2
  elsif arg.length > 5 && arg[0..4] == "--cc="
    cc_cmd = arg[5..arg.length - 1].to_s
    i = i + 1
  elsif arg.length > 0 && arg[0..0] == "-"
    puts "Unknown option: " + arg
    puts "Macronel Compiler"
    puts "Usage: ruby macronel.rb app.rb [options]"
    puts "Options:"
    puts "  -o FILE      Output executable or C file path"
    puts "  -c           Generate C source only (don't compile)"
    puts "  -S           Print generated C to stdout"
    puts "  -O LEVEL     Optimization level (default: 2)"
    puts "  --cc=CMD     C compiler command (default: gcc)"
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
  puts "Macronel Compiler"
  puts "Usage: ruby macronel.rb app.rb [options]"
  puts "Options:"
  puts "  -o FILE      Output executable or C file path"
  puts "  -c           Generate C source only (don't compile)"
  puts "  -S           Print generated C to stdout"
  puts "  -O LEVEL     Optimization level (default: 2)"
  puts "  --cc=CMD     C compiler command (default: gcc)"
  exit 1
end

if !File.exist?(src_file)
  puts "macronel: " + src_file + ": No such file"
  exit 1
end

# Use gsub to strip .rb to keep type inference simple
basename = File.basename(src_file).to_s.gsub(".rb", "")
is_win = true

if output_file == ""
  if c_only
    output_file = basename + ".c"
  else
    if is_win
      output_file = basename + ".exe"
    else
      output_file = basename
    end
  end
end

# Create temp files for intermediate compilation stages
tmp_ast = "tmp_" + basename + ".ast"
tmp_ir = "tmp_" + basename + ".ir"

if c_only
  tmp_c = output_file
else
  tmp_c = "tmp_" + basename + ".c"
end

# Set compilation options on Macronel module
Macronel.cc_cmd = cc_cmd.to_s
Macronel.opt_level = opt_level.to_s

success = true

# Step 1: Parse
puts "[Macronel] Parsing " + src_file + "..."
Macronel.parse(src_file, tmp_ast)

# Step 2: Expand macros
puts "[Macronel] Expanding macros..."
Macronel.expand_macros(tmp_ast)

# Step 3: Analyze
puts "[Macronel] Running type inference..."
Macronel.analyze(tmp_ast, tmp_ir)

# Step 4: Codegen
puts "[Macronel] Generating C code..."
Macronel.codegen(tmp_ast, tmp_ir, tmp_c)

# Step 5: Compile C
if !c_only && !stdout_mode
  puts "[Macronel] Compiling " + tmp_c + " to " + output_file + "..."
  success = Macronel.compile_c(tmp_c, output_file, cc_cmd, opt_level)
end

# Clean up
if File.exist?(tmp_ast)
  File.delete(tmp_ast)
end
if File.exist?(tmp_ir)
  File.delete(tmp_ir)
end

if !c_only
  if stdout_mode
    if File.exist?(tmp_c)
      puts File.read(tmp_c)
      File.delete(tmp_c)
    end
  else
    if File.exist?(tmp_c)
      File.delete(tmp_c)
    end
  end
end

if success
  puts "[Macronel] Compilation finished successfully."
else
  puts "[Macronel] Compilation failed."
  exit 1
end

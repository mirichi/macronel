# demo_shader.rb
# Macronelを用いたコンパイル時のGLSLシェーダー生成デモ

# Spinelの型推論用のダミー定義
module Macronel
  def self.node_content(nid); ""; end
  def self.node_type(nid); ""; end
  def self.node_name(nid); ""; end
  def self.node_body(nid); 0; end
  def self.node_arguments(nid); 0; end
  def self.node_block(nid); 0; end
  def self.get_stmts(nid); []; end
  def self.get_args(nid); []; end
  def self.to_ruby(nid); ""; end
  class << self
    attr_accessor :ast_table
  end
end

class MacronelTable
  def nd_stmts; [""]; end
end

# Dummy definition for editors/fallback
def glsl(&block); ""; end

# マクロ定義
module MacronelMacros
  register_macro :glsl

  # 宣言された変数や組み込み変数を保持する
  @declared_vars = ["gl_Position", "gl_FragCoord", "gl_VertexID", "gl_InstanceID"]

  def self.glsl(block_nid)
    body_id = Macronel.node_body(block_nid).to_i
    # ASTからGLSLコードをコンパイルし、Rubyの文字列リテラル表現にしてマクロ展開先に返す
    compile_shader(body_id).to_s.inspect.to_s
  end

  # ASTノードからGLSLの定義部をコンパイルする
  def self.compile_shader(nid)
    stmts = Macronel.get_stmts(nid)
    glsl_code = ""
    # 組み込み変数で初期化
    @declared_vars = ["gl_Position", "gl_FragCoord", "gl_VertexID", "gl_InstanceID"]
    
    i = 0
    while i < stmts.length
      stmt_id = stmts[i].to_i
      type = Macronel.node_type(stmt_id).to_s
      
      if type == "CallNode"
        name = Macronel.node_name(stmt_id).to_s
        args_id = Macronel.node_arguments(stmt_id).to_i
        args = args_id != -1 ? Macronel.get_args(args_id) : []
        
        if name == "version" && args.length == 1
          ver = Macronel.node_content(args[0].to_i).to_s
          glsl_code += "#version #{ver}\n"
        elsif (name == "input" || name == "output" || name == "uniform") && args.length == 2
          # シンボルから「:」を取り除いてGLSLの型と名前を出力
          glsl_type = Macronel.to_ruby(args[0].to_i).to_s.gsub(":", "")
          glsl_name = Macronel.to_ruby(args[1].to_i).to_s.gsub(":", "")
          
          # 変数名を宣言済みリストに追加
          @declared_vars << glsl_name
          
          glsl_keyword = name
          glsl_keyword = "in" if name == "input"
          glsl_keyword = "out" if name == "output"
          glsl_code += "#{glsl_keyword} #{glsl_type} #{glsl_name};\n"
        end
        
      elsif type == "DefNode"
        func_name = Macronel.node_name(stmt_id).to_s
        body_id = Macronel.node_body(stmt_id).to_i
        
        # 関数定義を出力（簡単にするため一旦main等はvoid型とする）
        glsl_code += "\nvoid #{func_name}() {\n"
        glsl_code += indent_lines(compile_shader_body(body_id))
        glsl_code += "}\n"
      end
      i += 1
    end
    glsl_code
  end

  # 関数内のインデント処理
  def self.indent_lines(code)
    lines = code.split("\n")
    res = ""
    i = 0
    while i < lines.length
      line = lines[i].to_s
      res += "    #{line}\n" if line.strip != ""
      i += 1
    end
    res
  end

  # 関数の中身（式リスト）をGLSL文に変換する
  def self.compile_shader_body(nid)
    return "" if nid < 0
    type = Macronel.node_type(nid).to_s
    
    if type == "StatementsNode"
      stmts = Macronel.get_stmts(nid)
      res = ""
      i = 0
      while i < stmts.length
        res += compile_shader_body(stmts[i].to_i)
        res += "\n" if i < stmts.length - 1
        i += 1
      end
      return res
    elsif type == "LocalVariableWriteNode" || type == "ConstantWriteNode"
      # 変数・定数への代入文
      name = Macronel.node_name(nid).to_s
      expr_id = Macronel.ast_table.nd_expression[nid].to_i
      return "#{name} = #{compile_shader_expr(expr_id)};"
    elsif type == "CallNode"
      # 式単体の呼び出し（例: discard;）
      return "#{compile_shader_expr(nid)};"
    else
      "/* 未対応のノードタイプ: #{type} */"
    end
  end

  # 右辺などの式をGLSLコード文字列に変換する
  def self.compile_shader_expr(nid)
    return "" if nid < 0
    type = Macronel.node_type(nid).to_s
    
    if type == "LocalVariableReadNode" || type == "ConstantReadNode"
      return Macronel.node_name(nid).to_s
    elsif type == "CallNode"
      recv = Macronel.node_receiver(nid).to_i
      name = Macronel.node_name(nid).to_s
      args_id = Macronel.node_arguments(nid).to_i
      args = args_id != -1 ? Macronel.get_args(args_id) : []
      
      # ２項演算子の判定
      if recv != -1 && args.length == 1 && ["+", "-", "*", "/", "==", "!=", "<", ">", "<=", ">="].include?(name)
        return "(#{compile_shader_expr(recv)} #{name} #{compile_shader_expr(args[0].to_i)})"
      end
      
      # 標準的な関数呼び出し（例: vec4(...) や texture(...)）
      args_strs = []
      i = 0
      while i < args.length
        args_strs.push(compile_shader_expr(args[i].to_i))
        i += 1
      end
      args_str = args_strs.join(", ")
      
      if recv != -1
        return "#{compile_shader_expr(recv)}.#{name}(#{args_str})"
      else
        if args.empty? && @declared_vars.include?(name)
          return name
        else
          return "#{name}(#{args_str})"
        end
      end
    elsif type == "FloatNode"
      val = Macronel.node_content(nid).to_s
      val += ".0" unless val.include?(".")
      return val
    elsif type == "IntegerNode"
      return Macronel.node_value(nid).to_s
    elsif type == "StringNode"
      return Macronel.node_content(nid).to_s
    else
      "/* 未対応の式タイプ: #{type} */"
    end
  end
end

# --- マクロの利用例 ---

vertex_shader = glsl do
  version "330 core"
  
  input :vec3, :aPos
  input :vec2, :aTexCoords
  
  output :vec2, :TexCoords
  
  def main
    gl_Position = vec4(aPos, 1.0)
    TexCoords = aTexCoords
  end
end

fragment_shader = glsl do
  version "330 core"
  
  input :vec2, :TexCoords
  output :vec4, :FragColor
  
  uniform :sampler2D, :screenTexture
  
  def main
    FragColor = texture(screenTexture, TexCoords)
  end
end

puts "=== 生成されたバーテックスシェーダー ==="
puts vertex_shader
puts ""
puts "=== 生成されたフラグメントシェーダー ==="
puts fragment_shader

# Macronel on CRuby

Macronelは、RubyのAOTコンパイラ「Spinel」上で動作するよう実装されたマクロエンジンです。

本プロジェクトは、SpinelのC言語コンパイル部分を使わず、標準のRubyインタプリタ（CRuby）上でMacronelマクロを展開して実行・実験できるようにした環境です。

---

## 仕組み

1. **パース**: `spinel_parse.rb` を使用して、Rubyソースをテキスト形式のASTに変換します。
2. **マクロ展開**: AST内からマクロ定義（`MacronelMacros`）を抽出し、一時スクリプトを用いて評価・展開を行います。
3. **Rubyコード再構築**: 展開されたASTを `Macronel.to_ruby` メソッドでRubyコードに戻します。
4. **実行**: 展開済みのコードを標準の `ruby` コマンドで実行します。

これにより、アセットの埋め込みやHTMLテンプレートDSL、LispやBrainfuckのコンパイルといったマクロをCRuby上で動かして実験することができます。

---

## 動作要件・プラットフォーム

- **OS**: クロスプラットフォーム（Windows, macOS, Linux）
- **Ruby**: Ruby 3.3以上（Prismライブラリが利用可能な環境）
- **依存ファイル**:
  - `spinel_parse.rb`: SpinelのC言語版パーサー `spinel_parse.c` をRubyに移植したものです。Prismを利用してASTを出力します。
  - `node_table_loader.rb`: SpinelのテキストASTフォーマットをRubyオブジェクトにロードするスクリプト（Spinelより拝借）。

---

## ファイル構成

```text
macronel/
├── lib/
│   └── macronel.rb         # Macronelコアエンジン
├── macronel_cruby.rb       # CRuby用CLIランナー
├── macronel.rb             # Spinel用CLIランナー
├── node_table_loader.rb    # ASTローダー
├── spinel_parse.rb         # Prism ASTシリアライザ（C版からRubyに移植）
├── demo_macro.rb           # デモ用マクロスクリプト
├── config.json             # デモ用設定ファイル
├── asset.txt               # デモ用テキストアセット
└── readme.md               # 本ドキュメント
```

---

## 使用方法

### 1. スクリプトの実行
マクロを展開し、CRuby上で実行します。
```bash
ruby macronel_cruby.rb demo_macro.rb
```

### 2. マクロ展開後のソースコード表示 (`-S`)
展開済みのRubyソースコードを標準出力に表示します。
```bash
ruby macronel_cruby.rb -S demo_macro.rb
```

### 3. マクロ展開後のソースコード保存 (`-o`)
展開された結果をファイルとして保存します。
```bash
ruby macronel_cruby.rb demo_macro.rb -o output.rb
```

---

## 謝辞 (Acknowledgements)

- **まつもとゆきひろ（Matz）氏**:
  Rubyの開発者であるまつもとゆきひろ氏に感謝いたします。Rubyの柔軟な言語仕様のおかげで、このようなマクロの仕組みを構成することができました。
- **Spinel**:
  パーサーなどの基盤を提供しているSpinelのコードを一部利用・拝借させていただきました。開発チームに感謝いたします。

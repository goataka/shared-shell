# shared-shell

Bash用シェルスクリプト・ライブラリ

## 概要

### ライブラリ

- **インポート**（[import.sh](import.sh)）
  - 相対ライブラリ読み込み
- **ロガー**（[logger/logger.sh](logger/logger.sh)）
  - ログレベル指定制御（DEBUG/INFO/WARN/ERROR）
  - ログ出力関数（log_debug, log_info, log_warn, log_error）
- **テストヘルパー**（[tests/test_helper.sh](tests/test_helper.sh)）
  - 標準アサーション（assert_equals, assert_true など）
  - パラメータ化テスト（execute_parameterized_test）
  - テスト実行関数（run_tests）
- **自動テスト検出・実行**（[tests/run_shell_tests.sh](tests/run_shell_tests.sh)）
  - 指定フォルダ下の`test_*.sh`を自動実行

### Copilot Instruction

- Shell用指示[.github/sh.instructions.md](.github/sh.instructions.md)）
  - 書き方ガイド
  - コーディング規約

## 使い方

### ログ出力

```bash
source logger/logger.sh

func() {
  log_debug "デバッグメッセージ"
  log_info "情報メッセージ"
  log_warn "警告メッセージ"
  log_error "エラーメッセージ"
}
```

### テスト作成

`tests/`に`test_*.sh`を作成:

```bash
#!/bin/bash
source "$(dirname "$0")/../import.sh"

import "tests/test_helper.sh"

my_test() {
  assert_equals "foo" "foo" "fooはfooと等しい"
}

main() {
  run_tests my_test
}
main "$@"
```

### 全テスト実行

```bash
bash tests/run_shell_tests.sh [search_dir] [--debug]
```

- `search_dir`（省略可）: テストスクリプトを探すディレクトリ（デフォルト:カレント）


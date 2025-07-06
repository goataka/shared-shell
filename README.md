# shared-shell

シェルスクリプト・ライブラリ

## 概要

### コーディング・ガイド

- 書き方ガイド[sh.instructions.md](.github/instructions/sh.instructions.md)）
  - 関数、引数、変数など

### ライブラリ

- **コア**（[core.sh](core.sh)）
  - ライブラリ利用(import, run)
- **ロガー**（[logger.sh](logger/logger.sh)）
  - ログレベル指定制御（DEBUG/INFO/WARN/ERROR）
  - ログ出力関数（log_debug, log_info, log_warn, log_error）
- **テストヘルパー**（[test_helper.sh](tests/test_helper.sh)）
  - アサーション（assert_equals, assert_true など）
  - パラメータ化テスト（execute_parameterized_test）
  - テスト実行（execute_tests）
- **自動テスト検出・実行**（[run_tests.sh](tests/run_tests.sh)）
  - テストファイル検索・実行

## 使い方

### セットアップ

```bash
git submodule add https://github.com/goataka/shared-shell.git .submodules/shared-shell
```

ref. [git submodules](https://git-scm.com/book/ja/v2/Git-のさまざまなツール-サブモジュール)

### ログ出力

```bash
#!/bin/bash
set -euo pipefail

source "<REPO_ROOT>/.submodules/shared-shell/core.sh"
import "logger/logger.sh"

func() {
  log_debug "デバッグメッセージ"
  log_info "情報メッセージ"
  log_warn "警告メッセージ"
  log_error "エラーメッセージ"
}
```

### ユニットテスト

```bash
#!/bin/bash
set -euo pipefail

source "<REPO_ROOT>/.submodules/shared-shell/core.sh" 
import "tests/test_helper.sh"

my_test() {
  assert_equals "foo" "foo" "fooはfooと等しい"
}

main() {
  execute_tests my_test
}

main "$@"
```

### 全テスト実行

```bash
#!/bin/bash
set -euo pipefail

source "<REPO_ROOT>/.submodules/shared-shell/core.sh" 

main() {
  run tests/run_tests.sh 
}

main "$@"
```

## 参考

- [Google - Bash Style Guide](https://google.github.io/styleguide/shellguide.html)
- [ShellCheck](https://www.shellcheck.net/)
  - [GitHub Actions](https://github.com/marketplace/actions/run-shellcheck-with-reviewdog)
- [GitHub Copilot - Custom Instructions](https://docs.github.com/ja/copilot/how-tos/custom-instructions)
  - [VSCode拡張機能](https://code.visualstudio.com/docs/copilot/copilot-customization)
  
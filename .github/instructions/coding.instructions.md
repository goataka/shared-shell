---
applyTo: "**/*.sh"
---
# Copilot Instruction for Coding

cf. [理解しやすいコードの書き方～理解容易性の7つの観点～](https://qiita.com/goataka/items/ae1959c29036dc4929fe)

## 前提

- **識別子（Identifier）**
  - 変数や関数などを他と区別するための名称や記号
- **区画（Block）**
  - 関数やクラスなど、コードのまとまり

## 識別子（Identifier）

### 名称：曖昧 -> 明瞭

識別子の名称は、曖昧ではなく、明瞭とする。

- **命名規則の準拠**
  - リポジトリで採用された命名規則に準拠する
- **適切な英語の使用**
  - プログラムで一般的に使われる英語を使用する
- **省略名の不使用**
  - 名称は省略せず記載する
- **マジックナンバーの不使用**
  - 意味を持った値には適切な名称をつける
- **説明変数/関数の利用**
  - 自明ではない値の場合、変数や関数を定義し、名称を付ける
- **列挙型の利用**
  - 定数をグループ化し、用途を明確にする
- **驚き最小の原則に準拠**
  - 名称と内容を一致させる
- **アノテーションコメントの利用**
  - 意図を表現しきれない時はコメントで残すが、コメントの意味も明示する

### 役割：複数 -> 単一

識別子の役割は、複数ではなく、単一とする。

- **単一責任の原則に準拠（SOLIDの1つ）**
  - 識別子が持つ責務は１つにする
- **モジュール分割**
  - 責務が複数ある場合、分割をする
- **関心の分離**
  - 関心（役割）により、分割をする
- **値オブジェクトの利用**
  - 役割の分離方法として、値の特性ごとに分割する
- **モジュールの凝集度**
  - 同じ役割で纏まるように、分割する
- **インターフェース分離の原則（SOLIDの1つ）**
  - 同じ役割ではないインタフェースは分割する
- **コマンド・クエリ分離の原則**
  - コマンドとクエリは別の関数に分割する

### 状態：可変 -> 不変

識別子の状態は、可変ではなく、不変とする。

- **定数の利用**
  - 変更されない値は変更できないようにする
  - 言語によっては`const`だけでなく、`readonly`なども利用可能である
- **不変オブジェクトの利用**
  - オブジェクトが持つ値を変更できないようする
- **値オブジェクトの利用**
  - 不変オブジェクト化する際に関連する機能群を集約する
- **継承の禁止**
  - 必要のないクラスの継承を禁止する
- **オーバーライドの禁止**
  - 必要のないオーバーライドを禁止する

### 参照：広域 -> 局所

識別子の参照は、広域ではなく、局所とする。

- **モジュールの疎結度**
  - モジュール間の結合度は低くする
- **値のスコープを狭くする**
  - グローバル、フィールド、ローカルとできるだけ狭くする

#### 参照

- **純粋関数への転換**
  - 外部との副作用を持たない関数やクラスに転換する
    - ex. グローバルや環境変数を直接参照せず、引数として受け取る

#### 被参照

- **データ隠蔽**
  - クラスが持つフィールドなどを直接参照させない
- **情報隠蔽**
  - 値を公開せず、必要な処理のみを公開する

## 区画（Block）

### 面積：広大 -> 狭小

区画の面積は、広大ではなく、狭小とする。

- **重複の除去（DRY原則）**
  - 同じ意味で重複したものは1つにする
- **関数の抽出**
  - まとまりごとに関数として抽出する

#### 縦：行数

主処理部分の行数は5～10行程度、全体としても20行程度に収める。

- **デッドコードの除去**
  - 利用されることのなくなった、できないコードは削除する
- **不使用コードの除去（YAGNI）**
  - 現時点で使わないコードは記述しない
- **nullの不使用**
  - 必要な時以外はnullを利用しない
- **値オブジェクトの利用**
  - 直接値を利用せず、値オブジェクトにする
- **3項演算子の利用**
  - 複雑ではない場合、3項演算子を利用する

##### コメント

- **退化コメントの除去**
  - 古くなったと分かったコメントは除外する
- **冗長コメントの除去**
  - 翻訳コメントなど意味のないコメントは除外する
- **コメントアウトの除去**
  - バージョン管理で確認できる内容を残さない

#### 横：字数

単純な行ではなく、一文として80字程度に収める。

- **パラメーターオブジェクトの利用**
  - 引数の数が多い場合、専用のオブジェクトを作成する
- **説明変数/関数の利用**
  - 冗長な条件判定は別途変数や関数に分割する

### 階層：多層 -> 単層

区画の階層は、多層ではなく、単層とする。

- **早期リターン**
  - 主処理の必要性ない条件は先に`return`や`exit`させてしまう
  - ガード節・アーリーリターンとも呼ばれる
  - 類型として、アーリー・コンティニュー もある
- **関数の抽出**
  - ネスト内の処理が多く、更にネストしている場合、別関数に分割する
- **配列・リスト操作関数への転換**
  - ネスト自体を必要としない記述方式に転換する

### 秩序：雑然 -> 整然

区画の秩序は、雑然ではなく、整然とする。

- **簡潔に単純にする（KISS）**
  - おおよそ簡潔かつ単純にする
- **コーディングスタイルの準拠**
  - リポジトリルールがある場合はそれに準拠する
- **段落分け**
  - 意図の纏まりごとに段落を分ける
- **関数の抽出**
  - 意図の纏まりの数が多い場合、それぞれを別の関数に分割する
- **高凝集化**
  - 意図が同じ内容を同じところに纏める
- **カプセル化**
  - データとロジックを同じところに纏める
- **対称性**
  - 大きな意図が同じ名称やブロックでは、対称性や相似性を高くする
- **インフラ・ドメインの分離**
  - ドメインとインフラ層のコードを混ぜない
- **粒度の統一**
  - ロジック内の粒度は統一して記載する

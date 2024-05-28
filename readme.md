# 使い方

Node.jsとyarn、Gitをあらかじめインストールしておいてくださいね！

Node.js
https://nodejs.jp/

Yarn
https://chore-update--yarnpkg.netlify.app/ja/

Git
https://git-scm.com/


1. プロジェクトのディレクトリを作成。（日本語や関連しない名前はNG）
1. このリポジトリをクローンする。
```
git clone [リポジトリのURL]
```
1. Git Bashを立ち上げる
1. 1で作成したフォルダ内で下記のコマンドを実行（Portを指定しない場合）

```
sh start.sh
```
👆MAC版はセキュリティの関係で実行が難しい可能性があるので、
失敗した場合はファイルの中身を開いて、ターミナルで全コードを張り付けで実行するとうまくいくケースがあります。

PORTを指定する場合はこちら
```
sh start.sh PORT=XXXX
```

## 実行方法

```
yarn run dev
```

こちらでWebブラウザが立ち上がり、編集が可能になっている


## 注意事項

このファイルは環境構築のみに利用するモノなので、2回目以降は実行しなくてOK。

再び業務を再開する場合は実行方法に記載されたコマンドのみでOK。
（じゃないとファイルが消えます）


## このファイルでやっていること

- LocalServer構築（hotReload)
- 初期のSCSSファイル、HTML、JSを作成
  - scssは便利なユーティリティを搭載しています
- git連携
- Basic認証の環境構築
- LocalIPのみ、スマホでも閲覧可能にしてます！
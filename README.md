症例候補の初期入力のプロトタイプ: フロントエンド
================================================

## NOTE

**重要**
今後は*https://github.com/ffhs-dev*で開発を進めることになりました。
FFHSはプライベートリポジトリなのでコードを見ることはできません。
ですので、このリポジトリは参照用として残しておきます。

## UIのビルド

- npmはインストール済みとする。

```
sh build.sh
```

build.shは 各step1,step2に対して下記コマンドを実行している。

```sh
cd ui/${step}
npm install
patch -p 0 -i ../vue-cli.patch
alias vue=`pwd`/node_modules/@vue/cli/bin/vue.js
npm run build
```

patchコマンドは disableAssetsSubdirを有効にしている。
ビルドする時に、getAssetPath.jsにパスが埋め込みなのを
無効にしてトップディレクトリに保存するパッチ。

vue-cliのバージョンによってはパッチが当たらない可能性もありえるので、
rejectされた場合は、下記2つを手で当てる。

```
diff -u node_modules/@vue/cli-service/lib/util/getAssetPath.js.orig node_modules/@vue/cli-service/lib/util/getAssetPath.js 
--- node_modules/@vue/cli-service/lib/options.js.orig	1985-10-26 17:15:00.000000000 +0900
+++ node_modules/@vue/cli-service/lib/options.js	2021-05-28 13:16:35.000000000 +0900
@@ -1,6 +1,7 @@
 const { createSchema, validate } = require('@vue/cli-shared-utils')
 
 const schema = createSchema(joi => joi.object({
+  disableAssetsSubdir: joi.boolean(),
   publicPath: joi.string().allow(''),
   outputDir: joi.string(),
   assetsDir: joi.string().allow(''),
diff -u node_modules/@vue/cli-service/lib/util/getAssetPath.js.orig node_modules/@vue/cli-service/lib/util/getAssetPath.js
--- node_modules/@vue/cli-service/lib/util/getAssetPath.js.orig	1985-10-26 17:15:00.000000000 +0900
+++ node_modules/@vue/cli-service/lib/util/getAssetPath.js	2021-05-28 13:18:51.000000000 +0900
@@ -1,6 +1,9 @@
 const path = require('path')
 
 module.exports = function getAssetPath (options, filePath) {
+  if (options.disableAssetsSubdir === true) {
+    filePath = filePath.replace(/^css\//, '').replace(/^js\//, '')
+  }
   return options.assetsDir
     ? path.posix.join(options.assetsDir, filePath)
     : filePath
```

## UIのデバッグ

- npmはインストール済みとする。
- 各stepの下に移動して`npm run serve`コマンドを起動する。

```
cd ui/step2
npm run serve
```


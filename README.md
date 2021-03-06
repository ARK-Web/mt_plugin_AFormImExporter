# mt_plugin_AFormImExporter
A-Formでつくったフォームのインポート/エクスポートができるプラグイン
====

ARK-Web/mt_plugin_AFormImExporter - A-Formでつくったフォームのインポート/エクスポートができるプラグインです。

### 概要

MT用フォーム作成プラグイン「A-Form」でつくったフォームをにインポート/エクスポートするプラグインです。

開発環境上でつくったフォームを本番環境に移す時や、サーバのお引っ越しの時に、あるいは簡単なフォームのバックアップツールとして、ご活用いただければ幸いです。


### 動作条件

* MT6 (MT6.3.5で検証済み)
* MTクラウド対応

※ただし、エクスポート元とインポート先のA-Formが同じバージョンである必要があります。

* 受付データやアクセスレポートはエクスポートされません。
* またインポート先に、元からある受付データやアクセスレポートはそのまま残ります（上書きされません）。


### ダウンロード

* [https://github.com/ARK-Web/mt_plugin_AFormImExporter](https://github.com/ARK-Web/mt_plugin_AFormImExporter)
* ライセンス: MIT License


### インストール

ダウンロードファイルを解凍しすると、[AFormImExporter]というフォルダが現れるので、
MT_INSTALL_DIR/plugins/ 配下にフォルダごとアップロードしてください。


### 使い方

MT管理画面にアクセスするとA-Formのメニューにインポート、エクスポートが追加されます。


### エクスポート

ドロップダウンからフォームを選択してエクスポートボタンを押すと、ダウンロードが始まります。


### インポート

エクスポートしたデータをアップロードするとインポートが実行されます。


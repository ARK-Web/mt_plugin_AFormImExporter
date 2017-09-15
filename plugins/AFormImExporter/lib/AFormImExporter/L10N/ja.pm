# A plugin for adding "A-Form" functionality.
# Copyright (c) 2008 ARK-Web Co.,Ltd.

package AFormImExporter::L10N::ja;

use strict;
use base qw( AFormImExporter::L10N::en_us );
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
	'_PLUGIN_AUTHOR' => 'ark-web',
	'_PLUGIN_DESCRIPTION' => 'A-Formのフォーム編集・詳細設定の内容をインポート/エクスポートするプラグインです',

	'Import' => 'インポート',
	'Export' => 'エクスポート',
	'Import A-Form' => 'A-Formインポート',
	'Export A-Form' => 'A-Formエクスポート',
	'Import description' => '<h4>注意点</h4>
<p>* インポートするデータと同じIDのフォームがある場合、上書きされます。</p>
<p>* バージョンの違うデータはインポートできません。</p>
<p>* インポートするだけです。再構築などは手動で行ってください。</p>',
	'Import successed' => '正常にインポートされました',
	'A-Form version error' => 'A-Formのバージョンが違います',
);
1;

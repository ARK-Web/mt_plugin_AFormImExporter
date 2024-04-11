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
<ul>
<li>バージョンの違うデータはインポートできません。</li>
<li>インポートするだけです。再構築などは手動で行ってください。</li>
</ul>',
	'Import successed' => '正常にインポートされました',
	'A-Form version error' => 'A-Formのバージョンが違います',
	'Import file' => 'インポートするファイル',
	'Import form' => 'インポート先のフォーム',
	'Import form hint' => 'インポート先のフォームを指定してください。',
	'New form' => '新規フォーム(新しくフォームを作成します)',
	'Same form' => '同じフォーム(インポートファイルと同じフォームIDのフォームを更新します)',
	'Other form' => '他のフォーム',
	'Please select form' => 'フォームを選択してください',
	'Import blog' => 'インポート先のサイト',
	'Same blog' => '同じサイト(インポートファイルと同じサイトIDのフォームとします)',
	'Other blog' => '他のサイト',
	'Please select blog' => 'サイトを選択してください',
);
1;

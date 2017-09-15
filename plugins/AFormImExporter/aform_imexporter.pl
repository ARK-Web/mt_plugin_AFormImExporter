# A plugin for adding "A-Form" functionality.
# Copyright (c) 2008 ARK-Web Co.,Ltd.

package MT::Plugin::AFormImExporter;

use strict;
use MT;

use vars qw( $VERSION );
$VERSION = '0.0.2';

use base qw( MT::Plugin );

###################################### Init Plugin #####################################

my $plugin = new MT::Plugin::AFormImExporter({
    id => 'AFormImExporter',
    name => 'A-Form ImExporter',
    author_name => '<MT_TRANS phrase=\'_PLUGIN_AUTHOR\'>',
    author_link => 'http://www.ark-web.jp/',
    version => $VERSION,
    description => '<MT_TRANS phrase=\'_PLUGIN_DESCRIPTION\'>',
    doc_link => 'http://www.ark-web.jp/movabletype/',
    l10n_class => 'AFormImExporter::L10N',
});
MT->add_plugin($plugin);

sub init_registry {
    my $plugin = shift;
    $plugin->registry({
        'applications' => {
            'cms' => {
                'methods' => {
                    'import_aform' => '$AFormImExporter::AFormImExporter::CMS::import_aform',
                    'import_aform_process' => '$AFormImExporter::AFormImExporter::CMS::import_aform_process',
                    'export_aform' => '$AFormImExporter::AFormImExporter::CMS::export_aform',
                    'export_aform_process' => '$AFormImExporter::AFormImExporter::CMS::export_aform_process',
                },
                menus => {
                    'aform:import' => {
                        label => 'Import',
                        mode => 'import_aform',
						order => 1000,
                    },
                    'aform:export' => {
                        label => 'Export',
                        mode => 'export_aform',
						order => 2000,
                    },
                },
            },
        },
    });
}

sub instance {$plugin}

1;

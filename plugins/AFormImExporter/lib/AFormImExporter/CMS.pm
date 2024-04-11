# A plugin for adding "A-Form" functionality.
# Copyright (c) 2008 ARK-Web Co.,Ltd.

package AFormImExporter::CMS;

use strict;
use MT::AForm;

sub import_aform {
    my $app = shift;

	my @sites;
	my $site_iter = MT::Website->load_iter();
	while (my $site = $site_iter->()) {
		push @sites, {
			id => $site->id,
			name => $site->name,
		};
		my @blogs = @{$site->blogs};
		foreach my $blog (@blogs) {
			push @sites, {
				id => $blog->id,
				name => "-- ". $blog->name,
			};
		}
	}
	my @aforms = MT::AForm->load();

	my %param = (
		'import_success' => $app->param('import_success') || '',
		'aform_id' => $app->param('aform_id') || '',
		'sites' => \@sites,
		'aforms' => \@aforms,
	);
	my $html = $app->load_tmpl('import_aform.tmpl', \%param);
	return $app->build_page($html, \%param);
}

sub import_aform_process {
	my $app = shift;
	my $q = $app->param;

	# read uploaded file
	my( $fh, $info ) = $app->upload_info('import_file');
	my $filename = $q->tmpFileName($fh);
	my( $version, %aform_values, @fields );
	_read_aform_dat($filename, \$version, \%aform_values, \@fields);

	# import blog
	my $import_blog = $app->param('import_blog') || '';
	if ($import_blog eq 'global') {
		$aform_values{'blog_id'} = 0;
	}
	elsif ($import_blog eq 'same') {
		# nothing to do
	}
	elsif ($import_blog eq 'other') {
		my $other_blog = $app->param('other_blog') || undef;
		return $app->error($app->translate("Please select blog")) unless $other_blog;
		$aform_values{'blog_id'} = $other_blog;
	}
	else {
		return $app->error($app->translate("Please select import blog"));
	}

	# import form
	my $import_form = $app->param('import_form') || '';
	if ($import_form eq 'new') {
		$aform_values{'id'} = undef;
	}
	elsif ($import_form eq 'same') {
		# nothing to do
	}
	elsif ($import_form eq 'other') {
		my $other_form = $app->param('other_form') || undef;
		return $app->error($app->translate("Please select form")) unless $other_form;
		$aform_values{'id'} = $other_form;
	}
	else {
		return $app->error($app->translate("Please select import form"));
	}

	my $aform_id = $aform_values{'id'};

	# check version
	my $plugin_aform = MT->component('AForm');
	my $aform_version = $plugin_aform->name . $plugin_aform->version;
	if( $version ne $aform_version ){
		return $app->error( $app->translate("A-Form version error") );
	}

	# save aform
	my $aform = MT::AForm->new;
	foreach my $key (keys %aform_values) {
		$aform->set_values({ $key => $aform_values{$key} });
	}
	$aform->save()
		or return $app->error( $app->translate("save aform error") . ':' . $aform->errstr );
	$aform_id = $aform->id;

	# delete all aform_fields
	MT::AFormField->remove({ 'aform_id' => $aform_id }) if $aform_id;

	# save aform_fields
	foreach my $tmp (@fields) {
		my $aform_field = MT::AFormField->new;
		my( %field_values ) = @$tmp;
		foreach my $key (keys %field_values) {
			$aform_field->set_values({ $key => $field_values{$key} });
		}
		$aform_field->id(undef);
		$aform_field->aform_id($aform_id);
		$aform_field->save()
			or return $app->error( $app->translate("save aform_field error") . ':' . $aform_field->errstr );
	}

    return $app->redirect( $app->uri( mode => 'import_aform', args => { blog_id => $app->param('blog_id') || '', import_success => 1, aform_id => $aform_id} ) );
}

sub export_aform {
    my $app = shift;

	my @aforms = MT::AForm->load();
	my %param = (
		'aforms' => \@aforms,
	);
	my $html = $app->load_tmpl('export_aform.tmpl', \%param);
	return $app->build_page($html, \%param);
}

sub export_aform_process {
	my $app = shift;

eval {
	my $aform_id = $app->param('aform_id')
		or return $app->error( $app->translate("Invalid request") );

	my $plugin_aform = MT->component('AForm');
	my $aform_version = $plugin_aform->name . $plugin_aform->version;

	my $aform = MT::AForm->load($aform_id)
		or return $app->error($app->translate("Load of aform '[_1]' failed: [_2]", $aform_id, MT::AForm->errstr));

	my @aform_fields = MT::AFormField->load({ aform_id => $aform_id }, { sort => 'sort_order' });

	my $file = sprintf("%s-%03d.dat", $aform_version, $aform_id);
	$file =~ s/\s/_/g;
	local $| = 1;
	$app->{no_print_body} = 1;
	$app->set_header( "Cache-Control" => "public" );
	$app->set_header( "Pragma" => "public" );
	$app->set_header( "Content-Disposition" => "attachment; filename=$file" );
	$app->send_http_header( "text/plain; charset=utf-8" );

	my $output;
	# output version
	$output = $aform_version . "\n";

	# output aform
	my @aform_values = ();
	my( %column_values ) = %{$aform->column_values};
	foreach my $col (keys %column_values){
		push @aform_values, $col;
		push @aform_values,	$column_values{$col};
	}
	$output .= _make_csv(@aform_values) . "\n";

	# output aform_fields
	foreach my $aform_field (@aform_fields){
		my @aform_field_values = ();
		( %column_values ) = %{$aform_field->column_values};
		foreach my $col (keys %column_values){
			push @aform_field_values, $col;
			push @aform_field_values, $column_values{$col};
		}
		$output .= _make_csv(@aform_field_values) . "\n";
	}
	$app->print(Encode::encode("utf8", $output));
};
if ($@) {
	my $err = $@;
	$app->log($err);
	return $app->error($err);
}

	return 1;
}

sub _make_csv {
	my( @values ) = @_;

	my $csv = join ',', map {(s/"/""/g or /[\r\n,]/) ? qq("$_") : $_} @values;
	return $csv;
}

sub _read_aform_dat {
	my( $filename, $ref_version, $ref_aform_values, $ref_fields ) = @_;

	my $cnt = 0;
	open(DATA, "< $filename") or die "cannot open $filename";
	while (my $line = <DATA>) {
		$line .= <DATA> while ($line =~ tr/"// % 2 and !eof(DATA));

		$line =~ s/(?:\x0D\x0A|[\x0D\x0A])?$/,/;
		my( @values ) = map {/^"(.*)"$/s ? scalar($_ = $1, s/""/"/g, $_) : $_}
						($line =~ /("[^"]*(?:""[^"]*)*"|[^,]*),/g);
		@values = map {$_ eq '' ? undef : $_} @values;
		if( $cnt == 0 ){
			$$ref_version = $values[0];
		}elsif( $cnt == 1 ){
			(%$ref_aform_values) = @values;
		}else{
			push @$ref_fields, \@values;
		}
		$cnt++;
	}
}

1;

#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use File::Temp;
use File::Slurp;
BEGIN { unshift( @INC, './lib' ) }

BEGIN {
    use Test::Most;
    use_ok('Bio::VertRes::Config::Recipes::RegisterAndQCStudy');
}

my $destination_directory_obj = File::Temp->newdir( CLEANUP => 1 );
my $destination_directory = $destination_directory_obj->dirname();

ok(
    (
        my $obj = Bio::VertRes::Config::Recipes::RegisterAndQCStudy->new(
            database    => 'my_database',
            config_base => $destination_directory,
            limits      => { project => ['ABC study( EFG )'] },
            reference_lookup_file => 't/data/refs.index',
            reference             => 'ABC',
        )
    ),
    'initalise creating files'
);
ok( ( $obj->create ), 'Create all the config files and toplevel files' );

ok((-e $destination_directory.'/my_database/my_database.ilm.studies'), 'study names file exists');
my $text = read_file( $destination_directory.'/my_database/my_database.ilm.studies' );
chomp($text);
is($text, "ABC study( EFG )", 'Study is in file');

ok( -e $destination_directory . '/my_database/qc/qc_ABC_study_EFG.conf', 'QC toplevel file' );
$text = read_file( $destination_directory . '/my_database/qc/qc_ABC_study_EFG.conf' );
my $input_config_file = eval($text);
is_deeply($input_config_file,{
  'max_failures' => 3,
  'db' => {
            'database' => 'my_database',
            'password' => undef,
            'user' => 'root',
            'port' => 3306,
            'host' => 'localhost'
          },
  'data' => {
              'db' => {
                        'database' => 'my_database',
                        'password' => undef,
                        'user' => 'root',
                        'port' => 3306,
                        'host' => 'localhost'
                      },
              'chr_regex' => '.*',
              'mapper' => 'bwa',
              'glf' => '/software/vertres/bin-external/glf',
              'do_samtools_rmdup' => 1,
              'fai_ref' => '/path/to/ABC.fa.fai',
              'gtype_confidence' => '1.2',
              'bwa_ref' => '/path/to/ABC.fa',
              'assembly' => 'ABC',
              'skip_genotype' => 1,
              'dont_wait' => 0,
              'mapviewdepth' => '/software/pathogen/external/apps/usr/bin/bindepth',
              'stats_ref' => '/path/to/ABC.fa.refstats',
              'exit_on_errors' => 0,
              'bwa_exec' => '/software/pathogen/external/apps/usr/bin/bwa',
              'adapters' => '/lustre/scratch108/pathogen/pathpipe/usr/share/solexa-adapters.fasta',
              'samtools' => '/software/pathogen/external/apps/usr/bin/samtools',
              'fa_ref' => '/path/to/ABC.fa',
              'snps' => '/lustre/scratch108/pathogen/pathpipe/usr/share/mousehapmap.snps.bin'
            },
  'limits' => {
                'project' => [
                               'ABC\ study\(\ EFG\ \)'
                             ]
              },
  'log' => '/nfs/pathnfs01/log/my_database/qc_ABC_study_EFG.log',
  'root' => '/lustre/scratch108/pathogen/pathpipe/my_database/seq-pipelines',
  'prefix' => '_',
  'module' => 'VertRes::Pipelines::TrackQC_Fastq'
},'Config file as expected');



ok(
    (
        $obj = Bio::VertRes::Config::Recipes::RegisterAndQCStudy->new(
            database    => 'my_database',
            config_base => $destination_directory,
            limits      => { project => ['ABC study( EFG )'], species => ['Cat', 'Dog'] },
            reference_lookup_file => 't/data/refs.index',
            reference             => 'ABC',
        )
    ),
    'initalise creating files with species'
);
ok( ( $obj->create ), 'Create all the config files and toplevel files with species' );

ok( -e $destination_directory . '/my_database/qc/qc_ABC_study_EFG_Cat_Dog.conf', 'QC toplevel file with species' );
$text = read_file( $destination_directory . '/my_database/qc/qc_ABC_study_EFG_Cat_Dog.conf' );
$input_config_file = eval($text);
is_deeply($input_config_file,{
  'max_failures' => 3,
  'db' => {
            'database' => 'my_database',
            'password' => undef,
            'user' => 'root',
            'port' => 3306,
            'host' => 'localhost'
          },
  'data' => {
              'db' => {
                        'database' => 'my_database',
                        'password' => undef,
                        'user' => 'root',
                        'port' => 3306,
                        'host' => 'localhost'
                      },
              'chr_regex' => '.*',
              'mapper' => 'bwa',
              'glf' => '/software/vertres/bin-external/glf',
              'do_samtools_rmdup' => 1,
              'fai_ref' => '/path/to/ABC.fa.fai',
              'gtype_confidence' => '1.2',
              'bwa_ref' => '/path/to/ABC.fa',
              'assembly' => 'ABC',
              'skip_genotype' => 1,
              'dont_wait' => 0,
              'mapviewdepth' => '/software/pathogen/external/apps/usr/bin/bindepth',
              'stats_ref' => '/path/to/ABC.fa.refstats',
              'exit_on_errors' => 0,
              'bwa_exec' => '/software/pathogen/external/apps/usr/bin/bwa',
              'adapters' => '/lustre/scratch108/pathogen/pathpipe/usr/share/solexa-adapters.fasta',
              'samtools' => '/software/pathogen/external/apps/usr/bin/samtools',
              'fa_ref' => '/path/to/ABC.fa',
              'snps' => '/lustre/scratch108/pathogen/pathpipe/usr/share/mousehapmap.snps.bin'
            },
  'limits' => {
                'project' => [
                               'ABC\ study\(\ EFG\ \)'
                             ],
                'species' => [
                               'Cat',
                               'Dog'
                             ]
              },
  'log' => '/nfs/pathnfs01/log/my_database/qc_ABC_study_EFG_Cat_Dog.log',
  'root' => '/lustre/scratch108/pathogen/pathpipe/my_database/seq-pipelines',
  'prefix' => '_',
  'module' => 'VertRes::Pipelines::TrackQC_Fastq'
},'Config file as expected with species limit');



done_testing();

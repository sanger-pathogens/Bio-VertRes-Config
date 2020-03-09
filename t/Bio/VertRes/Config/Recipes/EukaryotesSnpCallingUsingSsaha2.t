#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use File::Temp;
use File::Slurper qw[write_text read_text];
BEGIN { unshift( @INC, './lib' ) }

BEGIN {
    use Test::Most;
    use_ok('Bio::VertRes::Config::Recipes::EukaryotesSnpCallingUsingSsaha2');
}

my $destination_directory_obj = File::Temp->newdir( CLEANUP => 1 );
my $destination_directory = $destination_directory_obj->dirname();
$ENV{VERTRES_DB_CONFIG} = 't/data/database_connection_details';

ok(
    (
        my $obj = Bio::VertRes::Config::Recipes::EukaryotesSnpCallingUsingSsaha2->new(
            database    => 'my_database',
            config_base => $destination_directory,
            limits      => { project => ['ABC study( EFG )'] },
            reference_lookup_file => 't/data/refs.index',
            reference             => 'ABC'
        )
    ),
    'initalise creating files'
);
ok( ( $obj->create ), 'Create all the config files and toplevel files' );

# Are all the nessisary top level files there?
ok( -e $destination_directory . '/my_database/my_database.ilm.studies' , 'study names file exists');
ok( -e $destination_directory . '/my_database/my_database_import_cram_pipeline.conf', 'import toplevel file');
ok( -e $destination_directory . '/my_database/my_database_mapping_pipeline.conf', 'mapping toplevel file');
ok( -e $destination_directory . '/my_database/my_database_snps_pipeline.conf', 'snps toplevel file');

# Individual config files
ok((-e "$destination_directory/my_database/import_cram/import_cram_global.conf"), 'import config file exists');
ok((-e "$destination_directory/my_database/mapping/mapping_ABC_study_EFG_ABC_ssaha.conf"), 'mapping config file exists' );
ok((-e "$destination_directory/my_database/snps/snps_ABC_study_EFG_ABC.conf"), 'snps config file exists' );

my $text = read_text( "$destination_directory/my_database/mapping/mapping_ABC_study_EFG_ABC_ssaha.conf" );
my $input_config_file = eval($text);
$input_config_file->{prefix} = '_checked_elsewhere_';
is_deeply($input_config_file,{
  'db' => {
            'database' => 'my_database',
            'password' => 'some_password',
            'user' => 'some_user',
            'port' => 1234,
            'host' => 'some_hostname'
          },
  'data' => {
              'mark_duplicates' => 1,
              'do_recalibration' => 0,
              'db' => {
                        'database' => 'my_database',
                        'password' => 'some_password',
                        'user' => 'some_user',
                        'port' => 1234,
                        'host' => 'some_hostname'
                      },
              'get_genome_coverage' => 1,
              'dont_wait' => 0,
              'assembly_name' => 'ABC',
              'exit_on_errors' => 0,
              'add_index' => 1,
              'reference' => '/path/to/ABC.fa',
              'do_cleanup' => 1,
              'ignore_mapped_status' => 1,
              'slx_mapper' => 'ssaha',
              'slx_mapper_exe' => '/software/pathogen/external/apps/usr/local/ssaha2/ssaha2',
              '454_mapper_exe' => '/software/pathogen/external/apps/usr/local/ssaha2/ssaha2',
              '454_mapper' => 'ssaha'
            },
  'limits' => {
                'project' => [
                               'ABC\ study\(\ EFG\ \)'
                             ]
              },
  'vrtrack_processed_flags' => {
                                 'qc' => 1,
                                 'import' => 1
                               },
  'log' => '/nfs/pathnfs05/log/my_database/mapping_ABC_study_EFG_ABC_ssaha.log',
  'root' => '/lustre/scratch118/infgen/pathogen/pathpipe/my_database/seq-pipelines',
  'prefix' => '_checked_elsewhere_',
  'dont_use_get_lanes' => 1,
  'module' => 'VertRes::Pipelines::Mapping',
  'umask' => 23,
  'octal_permissions' => 488,
  'unix_group' => 'pathogen',
  'limit' => 40,
},'Mapping Config file as expected');


$text = read_text( "$destination_directory/my_database/snps/snps_ABC_study_EFG_ABC.conf" );
$input_config_file = eval($text);
$input_config_file->{prefix} = '_checked_elsewhere_';
is_deeply($input_config_file,{
  'db' => {
            'database' => 'my_database',
            'password' => 'some_password',
            'user' => 'some_user',
            'port' => 1234,
            'host' => 'some_hostname'
          },
  'data' => {
              'db' => {
                        'database' => 'my_database',
                        'password' => 'some_password',
                        'user' => 'some_user',
                        'port' => 1234,
                        'host' => 'some_hostname'
                      },
              'bsub_opts_long' => '-q normal -M3500000 -R \'select[type==X86_64 && mem>3500] rusage[mem=3500,tmp=16000]\'',
              'split_size_mpileup' => 300000000,
              'dont_wait' => 0,
              'task' => 'pseudo_genome,mpileup,update_db,cleanup',
              'bsub_opts' => '-q normal -M3500000 -R \'select[type==X86_64 && mem>3500] rusage[mem=3500,tmp=16000]\'',
              'mpileup_cmd' => 'samtools mpileup -d 1000 -DSug ',
              'ignore_snp_called_status' => 1,
              'tmp_dir' => '/lustre/scratch118/infgen/pathogen/tmp',
              'bsub_opts_mpileup' => '-q normal -R \'select[type==X86_64]\'',
              'fai_chr_regex' => '[\w\.\#]+',
              'fai_ref' => '/path/to/ABC.fa.fai',
              'max_jobs' => 100,
              'bam_suffix' => 'markdup.bam',
              'fa_ref' => '/path/to/ABC.fa'
            },
  'max_lanes' => 300,
  'limits' => {
                'project' => [
                               'ABC\ study\(\ EFG\ \)'
                             ]
              },
  'vrtrack_processed_flags' => {
                                 'qc' => 1,
                                 'import' => 1,
                                 'mapped' => 1
                               },
  'root' => '/lustre/scratch118/infgen/pathogen/pathpipe/my_database/seq-pipelines',
  'log' => '/nfs/pathnfs05/log/my_database/snps_ABC_study_EFG_ABC.log',
  'prefix' => '_checked_elsewhere_',
  'umask' => 23,
  'octal_permissions' => 488,
  'unix_group' => 'pathogen',
  'module' => 'VertRes::Pipelines::SNPs'
},'SNP calling Config file as expected');


done_testing();

#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use File::Temp;
use File::Slurper qw[write_text read_text];
BEGIN { unshift( @INC, './lib' ) }

BEGIN {
    use Test::Most;
    use_ok('Bio::VertRes::Config::Recipes::EukaryotesAssembly');
}

my $destination_directory_obj = File::Temp->newdir( CLEANUP => 1 );
my $destination_directory = $destination_directory_obj->dirname();
$ENV{VERTRES_DB_CONFIG} = 't/data/database_connection_details';

ok(
    (
            my $obj = Bio::VertRes::Config::Recipes::EukaryotesAssembly->new(
            database    => 'my_database',
            config_base => $destination_directory,
            limits      => { project => ['ABC study( EFG )'] }
        )
    ),
    'initalise creating files'
);
ok( ( $obj->create ), 'Create all the config files and toplevel files' );

# Check assembly file
ok( -e $destination_directory . '/my_database/assembly/assembly_ABC_study_EFG_velvet.conf', 'assembly toplevel file' );
my $text = read_text( $destination_directory . '/my_database/assembly/assembly_ABC_study_EFG_velvet.conf' );
my $input_config_file = eval($text);

is_deeply($input_config_file,{
  'max_failures' => 3,
  'db' => {
            'database' => 'my_database',
            'password' => 'some_password',
            'user' => 'some_user',
            'port' => 1234,
            'host' => 'some_hostname'
          },
  'data' => {
              'remove_primers' => 1,
              'genome_size' => 10000000,
              'db' => {
                        'database' => 'my_database',
                        'password' => 'some_password',
                        'user' => 'some_user',
                        'port' => 1234,
                        'host' => 'some_hostname'
                      },
              'error_correct' => 1,
              'assembler_exec' => '/software/pathogen/external/apps/usr/bin/velvet',
              'dont_wait' => 0,
              'primers_file' => '/lustre/scratch118/infgen/pathogen/pathpipe/usr/share/solexa-adapters.quasr',
              'assembler' => 'velvet',
              'seq_pipeline_root' => '/lustre/scratch118/infgen/pathogen/pathpipe/my_database/seq-pipelines',
              'normalise' => 0,
              'sga_exec' => '/software/pathogen/external/apps/usr/bin/sga',
              'tmp_directory' => '/lustre/scratch118/infgen/pathogen/pathpipe/tmp',
              'pipeline_version' => '2.3.1',
              'improve_assembly' => 1,
              'post_contig_filtering' => 300,
              'max_threads' => 6,
              'optimiser_exec' => '/software/pathogen/external/apps/usr/bin/VelvetOptimiser.pl',
              'iva_qc'		    => 0,
			  'kraken_db'		    => '/lustre/scratch118/infgen/pathogen/pathpipe/kraken/assemblyqc_fluhiv_20150728',
            },
  'max_lanes_to_search' => 10000,
  'limits' => {
                'project' => [
                               'ABC\\ study\\(\\ EFG\\ \\)'
                             ]
              },
  'vrtrack_processed_flags' => {
                                 'rna_seq_expression' => 0,
                                 'qc' => 1
                               },
  'root' => '/lustre/scratch118/infgen/pathogen/pathpipe/my_database/seq-pipelines',
  'log' => '/nfs/pathnfs05/log/my_database/assembly_ABC_study_EFG_velvet.log',
  'limit' => 100000,
  'module' => 'VertRes::Pipelines::Assembly',
  'umask' => 23,
  'octal_permissions' => 488,
  'unix_group' => 'pathogen',
  'prefix' => '_velvet_'
},'Config file as expected');

done_testing();

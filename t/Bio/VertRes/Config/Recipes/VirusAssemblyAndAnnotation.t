#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use File::Temp;
use File::Slurper qw[write_text read_text];

BEGIN { unshift( @INC, './lib' ) }

BEGIN {
    use Test::Most;
    use_ok('Bio::VertRes::Config::Recipes::VirusAssemblyAndAnnotation');
}

my $destination_directory_obj = File::Temp->newdir( CLEANUP => 1 );
my $destination_directory = $destination_directory_obj->dirname();
$ENV{VERTRES_DB_CONFIG} = 't/data/database_connection_details';

ok(
    (
            my $obj = Bio::VertRes::Config::Recipes::VirusAssemblyAndAnnotation->new(
            database    => 'my_database',
            config_base => $destination_directory,
            limits      => { project => ['ABC study( EFG )'] }
        )
    ),
    'initalise creating files'
);
ok( ( $obj->create ), 'Create all the config files and toplevel files' );

# Check assembly file - spades
ok( -e $destination_directory . '/my_database/assembly/assembly_ABC_study_EFG_spades.conf', 'assembly toplevel file' );
my $text = read_text( $destination_directory . '/my_database/assembly/assembly_ABC_study_EFG_spades.conf' );
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
              'assembler_exec' => '/software/pathogen/external/apps/usr/bin/spades-3.10.0.py',
              'dont_wait' => 0,
              'primers_file' => '/lustre/scratch118/infgen/pathogen/pathpipe/usr/share/solexa-adapters.quasr',
              'assembler' => 'spades',
              'seq_pipeline_root' => '/lustre/scratch118/infgen/pathogen/pathpipe/my_database/seq-pipelines',
              'normalise' => 1,
              'improve_assembly' => 1,
              'sga_exec' => '/software/pathogen/external/apps/usr/bin/sga',
              'tmp_directory' => '/lustre/scratch118/infgen/pathogen/pathpipe/tmp',
              'pipeline_version' => '3.1.1',
              'post_contig_filtering' => 300,
              'max_threads' => 2,
              'single_cell' => 0,
              'optimiser_exec' => '/software/pathogen/external/apps/usr/bin/spades-3.10.0.py',
              'iva_qc'		    => 1,
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
  'log' => '/nfs/pathnfs05/log/my_database/assembly_ABC_study_EFG_spades.log',
  'limit' => 100000,
  'umask' => 23,
  'octal_permissions' => 488,
  'unix_group' => 'pathogen',
  'module' => 'VertRes::Pipelines::Assembly',
  'prefix' => '_spades_'
},'Config file as expected');

# Check annotation file
ok( -e $destination_directory . '/my_database/annotate_assembly/annotate_assembly_ABC_study_EFG_spades.conf', 'annotate assembly toplevel file' );
$text = read_text( $destination_directory . '/my_database/annotate_assembly/annotate_assembly_ABC_study_EFG_spades.conf' );
$input_config_file = eval($text);

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
              'db' => {
                        'database' => 'my_database',
                        'password' => 'some_password',
                        'user' => 'some_user',
                        'port' => 1234,
                        'host' => 'some_hostname'
                      },
              'annotation_tool' => 'Prokka',
              'dont_wait' => 0,
              'assembler' => 'spades',
              'memory' => 5000,
              'tmp_directory' => '/lustre/scratch118/infgen/pathogen/pathpipe/tmp',
              'dbdir' => '/lustre/scratch118/infgen/pathogen/pathpipe/prokka',
              'pipeline_version' => 1,
              'kingdom' => 'Viruses',
            },
  'max_lanes_to_search' => 10000,
  'limits' => {
                'project' => [
                               'ABC\\ study\\(\\ EFG\\ \\)'
                             ]
              },
  'vrtrack_processed_flags' => {
                                 'assembled' => 1
                               },
  'root' => '/lustre/scratch118/infgen/pathogen/pathpipe/my_database/seq-pipelines',
  'log' => '/nfs/pathnfs05/log/my_database/annotate_assembly_ABC_study_EFG_spades.log',
  'limit' => 100000,
  'umask' => 23,
  'octal_permissions' => 488,
  'unix_group' => 'pathogen',
  'module' => 'VertRes::Pipelines::AnnotateAssembly',
  'prefix' => '_spades_ann_'
},'Config file as expected');


# Check iva config file with non-default options for iva_qc, iva_insert_size and iva_strand_bias
ok(
    (
            my $obj_iva = Bio::VertRes::Config::Recipes::VirusAssemblyAndAnnotation->new(
            database    => 'my_database',
            config_base => $destination_directory,
            limits      => { project => ['ABC study( EFG )'] },
            assembler   => 'iva',
            iva_qc      => 0,
            kraken_db   => '/some/path',
            iva_insert_size => 750,
            iva_strand_bias => 0.2,            
        )
    ),
    'initalise creating files'
);
ok( ( $obj_iva->create ), 'Create all the config files and toplevel files' );

# Check assembly file - iva
ok( -e $destination_directory . '/my_database/assembly/assembly_ABC_study_EFG_iva.conf', 'assembly toplevel file' );
my $text_iva = read_text( $destination_directory . '/my_database/assembly/assembly_ABC_study_EFG_iva.conf' );
my $input_config_file_iva = eval($text_iva);

is_deeply($input_config_file_iva,{
 'max_failures' => 3,
  'db' => {
            'database' => 'my_database',
            'password' => 'some_password',
            'user' => 'some_user',
            'port' => 1234,
            'host' => 'some_hostname'
          },
  'data' => {
              'remove_primers' => 0,
              'genome_size' => 10000000,
              'db' => {
                        'database' => 'my_database',
                        'password' => 'some_password',
                        'user' => 'some_user',
                        'port' => 1234,
                        'host' => 'some_hostname'
                      },
              'iva_strand_bias' => '0.2',
              'improve_assembly' => 0,
              'error_correct' => 0,
              'assembler_exec' => '/software/pathogen/external/bin/iva',
              'adapter_removal_tool' => 'iva',
              'kraken_db' => '/some/path',
              'primers_file' => undef,
              'assembler' => 'iva',
              'seq_pipeline_root' => '/lustre/scratch118/infgen/pathogen/pathpipe/my_database/seq-pipelines',
              'iva_insert_size' => 750,
              'normalise' => 0,
              'sga_exec' => '/software/pathogen/external/apps/usr/bin/sga',
              'tmp_directory' => '/lustre/scratch118/infgen/pathogen/pathpipe/tmp',
              'pipeline_version' => '5.0.0',
              'max_threads' => 8,
              'primer_removal_tool' => 'iva',
              'dont_wait' => 0,
              'trimmomatic_jar' => '/software/pathogen/external/apps/usr/local/Trimmomatic-0.32/trimmomatic-0.32.jar',
              'post_contig_filtering' => 300,
              'iva_qc' => 0,
              'adapters_file' => '/lustre/scratch118/infgen/pathogen/pathpipe/usr/share/solexa-adapters.fasta',
              'remove_adapters' => 0,
              'optimiser_exec' => '/software/pathogen/external/bin/iva'
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
  'log' => '/nfs/pathnfs05/log/my_database/assembly_ABC_study_EFG_iva.log',
  'limit' => 100000,
  'umask' => 23,
  'octal_permissions' => 488,
  'unix_group' => 'pathogen',
  'module' => 'VertRes::Pipelines::Assembly',
  'prefix' => '_iva_'
},'Config file as expected');


done_testing();

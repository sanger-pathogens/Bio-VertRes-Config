#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use File::Temp;
use File::Slurper qw[write_text read_text];
BEGIN { unshift( @INC, './lib' ) }

BEGIN {
    use Test::Most;
    use_ok('Bio::VertRes::Config::Recipes::BacteriaRegisterAndQCStudy');
}

my $destination_directory_obj = File::Temp->newdir( CLEANUP => 1 );
my $destination_directory = $destination_directory_obj->dirname();
$ENV{VERTRES_DB_CONFIG} = 't/data/database_connection_details';

ok(
    (
            my $obj = Bio::VertRes::Config::Recipes::BacteriaRegisterAndQCStudy->new(
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
my $text = read_text( $destination_directory.'/my_database/my_database.ilm.studies' );
chomp($text);
is($text, "ABC study( EFG )", 'Study is in file');

ok( -e $destination_directory . '/my_database/qc/qc_ABC_study_EFG.conf', 'QC toplevel file' );
$text = read_text( $destination_directory . '/my_database/qc/qc_ABC_study_EFG.conf' );
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
              'db' => {
                        'database' => 'my_database',
                        'password' => 'some_password',
                        'user' => 'some_user',
                        'port' => 1234,
                        'host' => 'some_hostname'
                      },
              'chr_regex' => '.*',
              'mapper' => 'bwa',
              'glf' => '/software/pathogen/external/apps/usr/bin/glf',
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
              'bwa_exec' => '/software/pathogen/external/apps/usr/local/bwa-0.6.1/bwa',
              'adapters' => '/lustre/scratch118/infgen/pathogen/pathpipe/usr/share/solexa-adapters.fasta',
              'kraken_db' => '/lustre/scratch118/infgen/pathogen/pathpipe/kraken/pi_qc_2015521/',
              'samtools' => '/software/pathogen/external/apps/usr/bin/samtools',
              'fa_ref' => '/path/to/ABC.fa',
              'gcdepth_R'         => '/software/pathogen/external/apps/usr/local/gcdepth/gcdepth.R',
              'snps' => '/lustre/scratch118/infgen/pathogen/pathpipe/usr/share/mousehapmap.snps.bin',
            },
  'limits' => {
                'project' => [
                               'ABC\ study\(\ EFG\ \)'
                             ]
              },
  'log' => '/nfs/pathnfs05/log/my_database/qc_ABC_study_EFG.log',
  'root' => '/lustre/scratch118/infgen/pathogen/pathpipe/my_database/seq-pipelines',
  'prefix' => '_',
  'umask' => 23,
  'octal_permissions' => 488,
  'unix_group' => 'pathogen',
  'module' => 'VertRes::Pipelines::TrackQC_Fastq'
},'Config file as expected');

# Check assembly file
ok( -e $destination_directory . '/my_database/assembly/assembly_ABC_study_EFG_velvet.conf', 'assembly toplevel file' );
$text = read_text( $destination_directory . '/my_database/assembly/assembly_ABC_study_EFG_velvet.conf' );
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
              'remove_primers' => 0,
              'genome_size' => 10000000,
              'db' => {
                        'database' => 'my_database',
                        'password' => 'some_password',
                        'user' => 'some_user',
                        'port' => 1234,
                        'host' => 'some_hostname'
                      },
              'error_correct' => 0,
              'assembler_exec' => '/software/pathogen/external/apps/usr/bin/velvet',
              'dont_wait' => 0,
              'primers_file' => '/lustre/scratch118/infgen/pathogen/pathpipe/usr/share/solexa-adapters.quasr',
              'assembler' => 'velvet',
              'seq_pipeline_root' => '/lustre/scratch118/infgen/pathogen/pathpipe/my_database/seq-pipelines',
              'normalise' => 0,
              'improve_assembly' => 1,
              'sga_exec' => '/software/pathogen/external/apps/usr/bin/sga',
              'tmp_directory' => '/lustre/scratch118/infgen/pathogen/pathpipe/tmp',
              'pipeline_version' => '2.0.1',
              'post_contig_filtering' => 300,
              'max_threads' => 2,
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

# Check annotation file
ok( -e $destination_directory . '/my_database/annotate_assembly/annotate_assembly_ABC_study_EFG_velvet.conf', 'annotate assembly toplevel file' );
$text = read_text( $destination_directory . '/my_database/annotate_assembly/annotate_assembly_ABC_study_EFG_velvet.conf' );
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
              'assembler' => 'velvet',
              'memory' => 5000,
              'tmp_directory' => '/lustre/scratch118/infgen/pathogen/pathpipe/tmp',
              'dbdir' => '/lustre/scratch118/infgen/pathogen/pathpipe/prokka',
              'pipeline_version' => 1,
              'kingdom' => 'Bacteria',
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
  'log' => '/nfs/pathnfs05/log/my_database/annotate_assembly_ABC_study_EFG_velvet.log',
  'limit' => 100000,
  'module' => 'VertRes::Pipelines::AnnotateAssembly',
  'umask' => 23,
  'octal_permissions' => 488,
  'unix_group' => 'pathogen',
  'prefix' => '_annotate_'
},'Config file as expected');



ok(
    (
        $obj = Bio::VertRes::Config::Recipes::BacteriaRegisterAndQCStudy->new(
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

# QC file
ok( -e $destination_directory . '/my_database/qc/qc_ABC_study_EFG_Cat_Dog.conf', 'QC toplevel file with species' );
$text = read_text( $destination_directory . '/my_database/qc/qc_ABC_study_EFG_Cat_Dog.conf' );
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
              'chr_regex' => '.*',
              'mapper' => 'bwa',
              'glf' => '/software/pathogen/external/apps/usr/bin/glf',
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
              'bwa_exec' => '/software/pathogen/external/apps/usr/local/bwa-0.6.1/bwa',
              'adapters' => '/lustre/scratch118/infgen/pathogen/pathpipe/usr/share/solexa-adapters.fasta',
              'kraken_db' => '/lustre/scratch118/infgen/pathogen/pathpipe/kraken/pi_qc_2015521/',
              'samtools' => '/software/pathogen/external/apps/usr/bin/samtools',
              'fa_ref' => '/path/to/ABC.fa',
              'gcdepth_R'         => '/software/pathogen/external/apps/usr/local/gcdepth/gcdepth.R',
              'snps' => '/lustre/scratch118/infgen/pathogen/pathpipe/usr/share/mousehapmap.snps.bin'
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
  'log' => '/nfs/pathnfs05/log/my_database/qc_ABC_study_EFG_Cat_Dog.log',
  'root' => '/lustre/scratch118/infgen/pathogen/pathpipe/my_database/seq-pipelines',
  'prefix' => '_',
  'umask' => 23,
  'octal_permissions' => 488,
  'unix_group' => 'pathogen',
  'module' => 'VertRes::Pipelines::TrackQC_Fastq'
},'Config file as expected with species limit');

# spades assembly file
ok(
    (
        $obj = Bio::VertRes::Config::Recipes::BacteriaRegisterAndQCStudy->new(
            database    => 'my_database',
            config_base => $destination_directory,
            limits      => { project => ['ABC study( EFG )'] },
            reference_lookup_file => 't/data/refs.index',
            reference             => 'ABC',
            assembler             => 'spades'
        )
    ),
    'initalise creating spades assembly file'
);
ok( ( $obj->create ), 'Create all the config files and toplevel files with spades' );

ok( -e $destination_directory . '/my_database/assembly/assembly_ABC_study_EFG_spades.conf', 'created toplevel spades' );
$text = read_text( $destination_directory . '/my_database/assembly/assembly_ABC_study_EFG_spades.conf' );
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
              'remove_primers' => 0,
              'genome_size' => 10000000,
              'db' => {
                        'database' => 'my_database',
                        'password' => 'some_password',
                        'user' => 'some_user',
                        'port' => 1234,
                        'host' => 'some_hostname'
                      },
              'error_correct' => 0,
              'assembler_exec' => '/software/pathogen/external/apps/usr/bin/spades-3.10.0.py',
              'dont_wait' => 0,
              'primers_file' => '/lustre/scratch118/infgen/pathogen/pathpipe/usr/share/solexa-adapters.quasr',
              'assembler' => 'spades',
              'seq_pipeline_root' => '/lustre/scratch118/infgen/pathogen/pathpipe/my_database/seq-pipelines',
              'normalise' => 0,
              'improve_assembly' => 1,
							'spades_opts'       => ' --careful --cov-cutoff auto ',
              'sga_exec' => '/software/pathogen/external/apps/usr/bin/sga',
              'tmp_directory' => '/lustre/scratch118/infgen/pathogen/pathpipe/tmp',
              'pipeline_version' => '3.0.1',
              'post_contig_filtering' => 300,
              'max_threads' => 2,
              'single_cell' => 0,
              'optimiser_exec' => '/software/pathogen/external/apps/usr/bin/spades-3.10.0.py',
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
  'log' => '/nfs/pathnfs05/log/my_database/assembly_ABC_study_EFG_spades.log',
  'limit' => 100000,
  'module' => 'VertRes::Pipelines::Assembly',
  'umask' => 23,
  'octal_permissions' => 488,
  'unix_group' => 'pathogen',
  'prefix' => '_spades_'
},'Config file as expected with spades assembler');

# Populate a new study
Bio::VertRes::Config::RegisterStudy->new(database => 'pathogen_prok_track', study_name => 'DDD',config_base => $destination_directory)->register_study_name();

ok(
    (
        $obj = Bio::VertRes::Config::Recipes::BacteriaRegisterAndQCStudy->new(
            database    => 'my_other_database',
            config_base => $destination_directory,
            limits      => { project => ['DDD'] },
            reference_lookup_file => 't/data/refs.index',
            reference             => 'ABC',
        )
    ),
    'Initialise with the study pointing at the wrong database'
);
ok( ( $obj->create ), 'the database name should have been updated to prevent the same study being registered in 2 different places' );

ok( -e $destination_directory . '/prokaryotes/qc/qc_DDD.conf', 'QC toplevel file with modified database' );
$text = read_text( $destination_directory . '/prokaryotes/qc/qc_DDD.conf' );
$input_config_file = eval($text);
is_deeply($input_config_file,{
  'max_failures' => 3,
  'db' => {
            'database' => 'pathogen_prok_track',
            'password' => 'some_password',
            'user' => 'some_user',
            'port' => 1234,
            'host' => 'some_hostname'
          },
  'data' => {
              'db' => {
                        'database' => 'pathogen_prok_track',
                        'password' => 'some_password',
                        'user' => 'some_user',
                        'port' => 1234,
                        'host' => 'some_hostname'
                      },
              'chr_regex' => '.*',
              'mapper' => 'bwa',
              'glf' => '/software/pathogen/external/apps/usr/bin/glf',
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
              'bwa_exec' => '/software/pathogen/external/apps/usr/local/bwa-0.6.1/bwa',
              'adapters' => '/lustre/scratch118/infgen/pathogen/pathpipe/usr/share/solexa-adapters.fasta',
              'kraken_db' => '/lustre/scratch118/infgen/pathogen/pathpipe/kraken/pi_qc_2015521/',
              'samtools' => '/software/pathogen/external/apps/usr/bin/samtools',
              'fa_ref' => '/path/to/ABC.fa',
              'gcdepth_R'         => '/software/pathogen/external/apps/usr/local/gcdepth/gcdepth.R',
              'snps' => '/lustre/scratch118/infgen/pathogen/pathpipe/usr/share/mousehapmap.snps.bin'
            },
  'limits' => {
                'project' => [
                               'DDD'
                             ],

              },
  'log' => '/nfs/pathnfs05/log/prokaryotes/qc_DDD.log',
  'root' => '/lustre/scratch118/infgen/pathogen/pathpipe/prokaryotes/seq-pipelines',
  'prefix' => '_',
  'umask' => 23,
  'octal_permissions' => 488,
  'unix_group' => 'pathogen',
  'module' => 'VertRes::Pipelines::TrackQC_Fastq'
},'Config file has modified database names');


done_testing();

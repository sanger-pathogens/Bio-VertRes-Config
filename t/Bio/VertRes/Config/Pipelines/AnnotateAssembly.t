#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use File::Temp;

BEGIN { unshift( @INC, './lib' ) }

BEGIN {
    use Test::Most;
    use_ok('Bio::VertRes::Config::Pipelines::AnnotateAssembly');
}
my $destination_directory_obj = File::Temp->newdir( CLEANUP => 1 );
my $destination_directory = $destination_directory_obj->dirname();

ok(
    (
        my $obj = Bio::VertRes::Config::Pipelines::AnnotateAssembly->new(
            database => 'my_database',
            config_base           => $destination_directory
        )
    ),
    'initialise assembly config'
);

is($obj->toplevel_action, '__VRTrack_AnnotateAssembly__', 'toplevel action name');
is_deeply(
    $obj->to_hash,
    {
              'max_failures' => 3,
              'db' => {
                        'database' => 'my_database',
                        'password' => undef,
                        'user' => 'root',
                        'port' => 3306,
                        'host' => 'localhost'
                      },
              'data' => {
                          'tmp_directory' => '/lustre/scratch108/pathogen/pathpipe/tmp',
                          'db' => {
                                    'database' => 'my_database',
                                    'password' => undef,
                                    'user' => 'root',
                                    'port' => 3306,
                                    'host' => 'localhost'
                                  },
                          'dbdir' => '/lustre/scratch108/pathogen/pathpipe/prokka',
                          'annotation_tool' => 'Prokka',
                          'dont_wait' => 0,
                          'assembler' => 'velvet',
                          'pipeline_version' => 1
                        },
              'max_lanes_to_search' => 1000,
              'vrtrack_processed_flags' => {
                                             'assembled' => 1,
                                             'annotated' => 0
                                           },
              'root' => '/lustre/scratch108/pathogen/pathpipe/my_database/seq-pipelines',
              'log' => '/nfs/pathnfs01/log/my_database/annotate_assembly_logfile.log',
              'limit' => 100,
              'module' => 'VertRes::Pipelines::AnnotateAssembly',
              'prefix' => '_annotate_'
            },
    'output hash constructed correctly'
);

is(
    $obj->config,
    $destination_directory . '/my_database/annotate_assembly/annotate_assembly_global.conf',
    'config file in expected format'
);
ok( $obj->create_config_file, 'Can run the create config file method' );
ok( ( -e $obj->config ), 'Config file exists' );


done_testing();

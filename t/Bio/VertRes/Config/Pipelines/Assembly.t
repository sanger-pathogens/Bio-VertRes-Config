#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use File::Temp;

BEGIN { unshift( @INC, './lib' ) }

BEGIN {
    use Test::Most;
    use_ok('Bio::VertRes::Config::Pipelines::Assembly');
}
my $destination_directory_obj = File::Temp->newdir( CLEANUP => 1 );
my $destination_directory = $destination_directory_obj->dirname();

ok(
    (
        my $obj = Bio::VertRes::Config::Pipelines::Assembly->new(
            database => 'my_database',
            config_base           => $destination_directory
        )
    ),
    'initialise assembly config'
);

is($obj->toplevel_action, '__VRTrack_Assembly__');

is_deeply(
    $obj->to_hash,
    {
        'max_failures' => 3,
        'db'           => {
            'database' => 'my_database',
            'password' => undef,
            'user'     => 'root',
            'port'     => 3306,
            'host'     => 'localhost'
        },
        'data' => {
            'genome_size' => 10000000,
            'db'          => {
                'database' => 'my_database',
                'password' => undef,
                'user'     => 'root',
                'port'     => 3306,
                'host'     => 'localhost'
            },
            'assembler_exec'    => '/software/pathogen/external/apps/usr/bin/velvet',
            'dont_wait'         => 0,
            'assembler'         => 'velvet',
            'seq_pipeline_root' => '/lustre/scratch108/pathogen/pathpipe/my_database/seq-pipelines',
            'tmp_directory'     => '/lustre/scratch108/pathogen/pathpipe/tmp',
            'max_threads'       => 1,
            'pipeline_version'  => 2,
            'error_correct'     => 0,
            'sga_exec'          => '/software/pathogen/external/apps/usr/bin/sga',
            'optimiser_exec'    => '/software/pathogen/external/apps/usr/bin/VelvetOptimiser.pl'
        },
        'max_lanes_to_search'     => 200,
        'vrtrack_processed_flags' => {
            'assembled'          => 0,
            'rna_seq_expression' => 0,
            'stored'             => 1
        },
        'root'   => '/lustre/scratch108/pathogen/pathpipe/my_database/seq-pipelines',
        'log'    => '/nfs/pathnfs01/log/my_database/assembly_logfile.log',
        'limit'  => 100,
        'module' => 'VertRes::Pipelines::Assembly',
        'prefix' => '_assembly_'
    },
    'output hash constructed correctly'
);

is(
    $obj->config,
    $destination_directory . '/my_database/assembly/assembly_global.conf',
    'config file in expected format'
);
ok( $obj->create_config_file, 'Can run the create config file method' );
ok( ( -e $obj->config ), 'Config file exists' );


done_testing();

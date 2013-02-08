#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use File::Temp;

BEGIN { unshift( @INC, './lib' ) }

BEGIN {
    use Test::Most;
    use_ok('Bio::VertRes::Config::Pipelines::QC');
}

my $destination_directory_obj = File::Temp->newdir( CLEANUP => 1 );
my $destination_directory = $destination_directory_obj->dirname();


my $obj;
ok(
    (
        $obj = Bio::VertRes::Config::Pipelines::QC->new(
            database              => 'my_database',
            reference_lookup_file => 't/data/refs.index',
            reference             => 'ABC',
            limits                => { project => ['ABC study( EFG )'] },
            config_base           => $destination_directory
        )
    ),
    'initialise qc config'
);
is($obj->toplevel_action, '__VRTrack_QC__');
is_deeply(
    $obj->to_hash,
    {
        'limits' => {
            'project' => ['ABC\ study\(\ EFG\ \)']
        },
        'max_failures' => 3,
        'db'           => {
            'database' => 'my_database',
            'password' => undef,
            'user'     => 'root',
            'port'     => 3306,
            'host'     => 'localhost'
        },
        'data' => {
            'chr_regex' => '.*',
            'db'        => {
                'database' => 'my_database',
                'password' => undef,
                'user'     => 'root',
                'port'     => 3306,
                'host'     => 'localhost'
            },
            'glf'               => '/software/vertres/bin-external/glf',
            'mapper'            => 'bwa',
            'do_samtools_rmdup' => 1,
            'fai_ref'           => '/path/to/ABC.fa.fai',
            'gtype_confidence'  => '1.2',
            'bwa_ref'           => '/path/to/ABC.fa',
            'assembly'          => 'ABC',
            'skip_genotype'     => 1,
            'dont_wait'         => 0,
            'mapviewdepth'      => '/software/pathogen/external/apps/usr/bin/bindepth',
            'stats_ref'         => '/path/to/ABC.fa.refstats',
            'exit_on_errors'    => 0,
            'bwa_exec'          => '/software/pathogen/external/apps/usr/bin/bwa',
            'samtools'          => '/software/pathogen/external/apps/usr/bin/samtools',
            'adapters'          => '/lustre/scratch108/pathogen/pathpipe/usr/share/solexa-adapters.fasta',
            'fa_ref'            => '/path/to/ABC.fa',
            'snps'              => '/lustre/scratch108/pathogen/pathpipe/usr/share/mousehapmap.snps.bin'
        },
        'log'    => '/nfs/pathnfs01/log/my_database/qc_ABC_study_EFG.log',
        'root'   => '/lustre/scratch108/pathogen/pathpipe/my_database/seq-pipelines',
        'prefix' => '_',
        'module' => 'VertRes::Pipelines::TrackQC_Fastq'
    },
    'output hash constructed correctly'
);

is(
    $obj->config,
    $destination_directory . '/my_database/qc/qc_ABC_study_EFG.conf',
    'config file in expected format'
);
ok( $obj->create_config_file, 'Can run the create config file method' );
ok( ( -e $obj->config ), 'Config file exists' );


ok(
    (
        $obj = Bio::VertRes::Config::Pipelines::QC->new(
            database              => 'my_database',
            reference_lookup_file => 't/data/refs.index',
            reference             => 'ABC',
            limits                => {
                project     => [ 'study 1',  'study 2' ],
                sample      => [ 'sample 1', 'sample 2' ],
                species     => ['species 1'],
                other_stuff => ['some other stuff']
            },
            config_base         => '/tmp'
        )
    ),
    'initialise qc config with multiple limits'
);

is_deeply(
    $obj->_escaped_limits,
    {
        'project'     => [ 'study\ 1',  'study\ 2' ],
        'sample'      => [ 'sample\ 1', 'sample\ 2' ],
        'species'     => [ 'species\ 1' ],
        'other_stuff' => [ 'some\ other\ stuff' ]
    },
    'Check escaped limits are as expected'
);
is_deeply(
    $obj->limits,
    {
        'project'     => [ 'study 1',  'study 2' ],
        'sample'      => [ 'sample 1', 'sample 2' ],
        'species'     => ['species 1'],
        'other_stuff' => ['some other stuff']
    },
    'Check the input limits are unchanged'
);

done_testing();

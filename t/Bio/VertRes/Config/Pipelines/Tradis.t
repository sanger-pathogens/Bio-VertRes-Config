#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;

BEGIN { unshift( @INC, './lib' ) }

BEGIN {
    use Test::Most;
    use_ok('Bio::VertRes::Config::Pipelines::Tradis');
}

my $obj;
ok(
    (
        $obj = Bio::VertRes::Config::Pipelines::Tradis->new(
            database              => 'my_database',
            reference_lookup_file => 't/data/refs.index',
            reference             => 'ABC',
            limits                => { project => ['ABC study( EFG )'] },
        )
    ),
    'initialise tradis config'
);
is($obj->toplevel_action, '__VRTrack_RNASeqExpression__');
my $returned_config_hash = $obj->to_hash;
my $prefix               = $returned_config_hash->{prefix};
ok( ( $prefix =~ m/_[\d]{10}_[\d]{1,4}_/ ), 'check prefix pattern is as expected' );
$returned_config_hash->{prefix} = '_checked_elsewhere_';

is_deeply(
    $returned_config_hash,
    {
              'limits' => {
                            'project' => [
                                           'ABC\ study\(\ EFG\ \)'
                                         ]
                          },
              'vrtrack_processed_flags' => {
                                             'stored' => 1,
                                             'mapped' => 1,
                                             'import' => 1
                                           },
              'db' => {
                        'database' => 'my_database',
                        'password' => undef,
                        'user' => 'root',
                        'port' => 3306,
                        'host' => 'localhost'
                      },
              'data' => {
                          'annotation_file' => '/path/to/ABC.gff',
                          'protocol' => 'TradisProtocol',
                          'ignore_rnaseq_called_status' => 1,
                          'intergenic_regions' => 1,
                          'db' => {
                                    'database' => 'my_database',
                                    'password' => undef,
                                    'user' => 'root',
                                    'port' => 3306,
                                    'host' => 'localhost'
                                  },
                          'dont_wait' => 0,
                          'mapping_quality' => 10,
                          'sequencing_file_suffix' => 'markdup.bam'
                        },
              'log' => '/nfs/pathnfs01/log/my_database/tradis__ABC_study_EFG_ABC.log',
              'root' => '/lustre/scratch108/pathogen/pathpipe/my_database/seq-pipelines',
              'prefix' => '_checked_elsewhere_',
              'module' => 'VertRes::Pipelines::RNASeqExpression'
            },
    'Expected base config file'
);


done_testing();
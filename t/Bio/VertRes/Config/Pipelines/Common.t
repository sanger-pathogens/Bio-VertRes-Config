#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use File::Temp;
use File::Slurper qw[write_text read_text];

BEGIN { unshift( @INC, './lib' ) }

BEGIN {
    use Test::Most;
    use_ok('Bio::VertRes::Config::Pipelines::Common');
}

my $destination_directory_obj = File::Temp->newdir( CLEANUP => 1 );
my $destination_directory = $destination_directory_obj->dirname();
$ENV{VERTRES_DB_CONFIG} = 't/data/database_connection_details';

ok(
    (
        my $obj = Bio::VertRes::Config::Pipelines::Common->new(
            database            => 'my_database',
            pipeline_short_name => 'new_pipeline',
            module              => 'Bio::Example',
            toplevel_action     => '__VRTrack_Action__',
            root_base           => '/path/to/root',
            log_base            => '/path/to/log',
            config_base         => $destination_directory
        )
    ),
    'initialise common config'
);

is_deeply(
    $obj->to_hash,
    {
        'db' => {
            'database' => 'my_database',
            'password' => 'some_password',
            'user'     => 'some_user',
            'port'     => 1234,
            'host'     => 'some_hostname'
        },
        'data' => {
            'db' => {
                'database' => 'my_database',
                'password' => 'some_password',
                'user'     => 'some_user',
                'port'     => 1234,
                'host'     => 'some_hostname'
            },
            'dont_wait' => 0
        },
        'log'    => '/path/to/log/my_database/new_pipeline_logfile.log',
        'root'   => '/path/to/root/my_database/seq-pipelines',
        'prefix' => '_',
	    'umask' => 23,
	    'octal_permissions' => 488,
	    'unix_group' => 'pathogen',
        'module' => 'Bio::Example'
    },
    'output hash constructed correctly'
);

is(
    $obj->config,
    $destination_directory . '/my_database/new_pipeline/new_pipeline_global.conf',
    'config file in expected format'
);
ok( $obj->create_config_file, 'Can run the create config file method' );
ok( ( -e $obj->config ), 'Config file exists' );

my $text              = read_text( $obj->config );
my $input_config_file = eval($text);
is_deeply(
    $input_config_file,
    {
        'db' => {
            'database' => 'my_database',
            'password' => 'some_password',
            'user'     => 'some_user',
            'port'     => 1234,
            'host'     => 'some_hostname'
        },
        'data' => {
            'db' => {
                'database' => 'my_database',
                'password' => 'some_password',
                'user'     => 'some_user',
                'port'     => 1234,
                'host'     => 'some_hostname'
            },
            'dont_wait' => 0
        },
        'log'    => '/path/to/log/my_database/new_pipeline_logfile.log',
        'root'   => '/path/to/root/my_database/seq-pipelines',
        'prefix' => '_',
	    'umask' => 23,
	    'octal_permissions' => 488,
	    'unix_group' => 'pathogen',
        'module' => 'Bio::Example'
    },
    'Can pull in file correctly and parse it'
);

ok(
    (
        my $obj_non_standard = Bio::VertRes::Config::Pipelines::Common->new(
            database            => 'pathogen_prok_track',
            pipeline_short_name => 'new_pipeline',
            module              => 'Bio::Example',
            toplevel_action     => '__VRTrack_Action__',
            root_base           => '/path/to/root',
            log_base            => '/path/to/log',
            config_base         => $destination_directory
        )
    ),
    'initialise common config for pipeline with non standard root'
);
is_deeply(
    $obj_non_standard->to_hash,
    {
        'db' => {
            'database' => 'pathogen_prok_track',
            'password' => 'some_password',
            'user'     => 'some_user',
            'port'     => 1234,
            'host'     => 'some_hostname'
        },
        'data' => {
            'db' => {
                'database' => 'pathogen_prok_track',
                'password' => 'some_password',
                'user'     => 'some_user',
                'port'     => 1234,
                'host'     => 'some_hostname'
            },
            'dont_wait' => 0
        },
        'log'    => '/path/to/log/prokaryotes/new_pipeline_logfile.log',
        'root'   => '/path/to/root/prokaryotes/seq-pipelines',
        'prefix' => '_',
	    'umask' => 23,
	    'octal_permissions' => 488,
	    'unix_group' => 'pathogen',
        'module' => 'Bio::Example'
    },
    'output hash has translated db name in root path'
);


ok(
    (
        my $obj_database_connection_file = Bio::VertRes::Config::Pipelines::Common->new(
            database            => 'pathogen_prok_track',
            pipeline_short_name => 'new_pipeline',
            module              => 'Bio::Example',
            toplevel_action     => '__VRTrack_Action__',
            root_base           => '/path/to/root',
            log_base            => '/path/to/log',
            config_base         => $destination_directory
        )
    ),
    'initialise common config without a specified database connection details file'
);

ok(
    (
        $obj_database_connection_file = Bio::VertRes::Config::Pipelines::Common->new(
            database            => 'pathogen_prok_track',
            pipeline_short_name => 'new_pipeline',
            module              => 'Bio::Example',
            toplevel_action     => '__VRTrack_Action__',
            root_base           => '/path/to/root',
            log_base            => '/path/to/log',
            config_base         => $destination_directory,
            database_connect_file => 't/data/does_not_exist'
        )
    ),
    'initialise common config when database connection details file doesnt exist'
);

throws_ok(
    sub { $obj_database_connection_file->to_hash },
    qr/Couldnt find database connect file t\/data\/does_not_exist/,
    'cannot get output hash from database connection file that doesnt exist.'
);

done_testing();

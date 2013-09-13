#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use File::Temp;
use File::Slurp;
BEGIN { unshift( @INC, './lib' ) }

BEGIN {
    use Test::Most;
    use_ok('Bio::VertRes::Config::CommandLine::BacteriaSnpCalling');
}

my $destination_directory_obj = File::Temp->newdir( CLEANUP => 1 );
my $destination_directory = $destination_directory_obj->dirname();

open(my $copy_stdout, ">&STDOUT"); close(STDOUT); open(STDOUT, ">", "/dev/null"); # copy stdout

my @input_args = qw(-t study -i ZZZ -r ABC -l t/data/refs.index -c);
push(@input_args, $destination_directory);
ok( my $obj_default = Bio::VertRes::Config::CommandLine::BacteriaSnpCalling->new(args => \@input_args, script_name => 'name_of_script' ), 'initialise commandline bacteria snp-calling (default)');
ok( $obj_default->run, 'run commandline bacteria snp-calling (default)');
my $mapping_params = $obj_default->mapping_parameters;
$mapping_params->{config_base} = 'no need to check';
is_deeply($mapping_params, {
          'protocol' => 'StrandSpecificProtocol',
          'overwrite_existing_config_file' => 0,
          'reference_lookup_file' => 't/data/refs.index',
          'database' => 'pathogen_prok_track',
          'database_connect_file' => '/software/pathogen/config/database_connection_details',
          'limits' => {
                        'project' => [
                                       'ZZZ'
                                     ]
                      },
          'reference' => 'ABC',
          'additional_mapper_params' => ' -r -1',
          'root_base' => '/lustre/scratch108/pathogen/pathpipe',
          'log_base'  => '/nfs/pathnfs05/log',
          'config_base' => 'no need to check'
          
        }, 'Mapping parameters include default smalt parameters');

@input_args = qw(-t study -i ZZZ -r ABC --smalt_mapper_r 0 -l t/data/refs.index -c);
push(@input_args, $destination_directory);
ok( my $obj_user = Bio::VertRes::Config::CommandLine::BacteriaSnpCalling->new(args => \@input_args, script_name => 'name_of_script' ), 'initialise commandline bacteria snp-calling (smalt_mapper_r = 0)');
ok( $obj_user->run, 'run commandline bacteria snp-calling (smalt_mapper_r = 0)');
$mapping_params = $obj_user->mapping_parameters;
$mapping_params->{config_base} = 'no need to check';
is_deeply($mapping_params, {
          'protocol' => 'StrandSpecificProtocol',
          'overwrite_existing_config_file' => 0,
          'reference_lookup_file' => 't/data/refs.index',
          'database' => 'pathogen_prok_track',
          'database_connect_file' => '/software/pathogen/config/database_connection_details',
          'limits' => {
                        'project' => [
                                       'ZZZ'
                                     ]
                      },
          'reference' => 'ABC',
          'additional_mapper_params' => ' -r 0',
          'root_base' => '/lustre/scratch108/pathogen/pathpipe',
          'log_base'  => '/nfs/pathnfs05/log',
          'config_base' => 'no need to check'
          
        }, 'Mapping parameters include user smalt parameters');

@input_args = qw(-t study -i ZZZ -r ABC -m bwa -l t/data/refs.index -c);
push(@input_args, $destination_directory);
ok( my $obj_bwa = Bio::VertRes::Config::CommandLine::BacteriaSnpCalling->new(args => \@input_args, script_name => 'name_of_script' ), 'initialise commandline bacteria snp-calling (bwa)');
ok( $obj_bwa->run, 'run commandline bacteria snp-calling (bwa)');
$mapping_params = $obj_bwa->mapping_parameters;
$mapping_params->{config_base} = 'no need to check';
is_deeply($mapping_params, {
          'protocol' => 'StrandSpecificProtocol',
          'overwrite_existing_config_file' => 0,
          'reference_lookup_file' => 't/data/refs.index',
          'database' => 'pathogen_prok_track',
          'database_connect_file' => '/software/pathogen/config/database_connection_details',
          'limits' => {
                        'project' => [
                                       'ZZZ'
                                     ]
                      },
          'reference' => 'ABC',
          'root_base' => '/lustre/scratch108/pathogen/pathpipe',
          'log_base'  => '/nfs/pathnfs05/log',
          'config_base' => 'no need to check'
          
        }, 'Mapping parameters ok for bwa');

close(STDOUT); open(STDOUT, ">&", $copy_stdout); # restore stdout
done_testing();


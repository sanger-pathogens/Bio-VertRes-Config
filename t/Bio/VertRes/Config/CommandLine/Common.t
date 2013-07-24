#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use File::Temp;
use File::Slurp;
BEGIN { unshift( @INC, './lib' ) }

BEGIN {
    use Test::Most;
    use_ok('Bio::VertRes::Config::CommandLine::Common');
}

my $destination_directory_obj = File::Temp->newdir( CLEANUP => 1 );
my $destination_directory = $destination_directory_obj->dirname();

my @input_args = qw(-t study -i ZZZ -r ABC -m smalt --smalt_index_k 15 --smalt_index_s 4 --smalt_mapper_r 1 --smalt_mapper_y 0.9 --smalt_mapper_x --smalt_mapper_l pe -c);
push(@input_args, $destination_directory);
ok( my $obj = Bio::VertRes::Config::CommandLine::Common->new(args => \@input_args, script_name => 'name_of_script' ), 'initialise commandline common obj');
my $mapping_params = $obj->mapping_parameters;
$mapping_params->{config_base} = 'no need to check';
is_deeply($mapping_params, {
          'protocol' => 'StrandSpecificProtocol',
          'overwrite_existing_config_file' => 0,
          'reference_lookup_file' => '/lustre/scratch108/pathogen/pathpipe/refs/refs.index',
          'database' => 'pathogen_prok_track',
          'limits' => {
                        'project' => [
                                       'ZZZ'
                                     ]
                      },
          'mapper_index_params' => '-k 15 -s 4',
          'reference' => 'ABC',
          'additional_mapper_params' => ' -r 1 -y 0.9 -x -l pe',
          'config_base' => 'no need to check'
          
        }, 'Mapping parameters include smalt parameters');

@input_args = qw(-t study -i ZZZ -r ABC -m smalt --smalt_mapper_l xxx -c);
push(@input_args, $destination_directory);
throws_ok(
    sub {
        Bio::VertRes::Config::CommandLine::Common->new(args => \@input_args, script_name => 'name_of_script' )->_construct_smalt_additional_mapper_params;
    },
    qr/Invalid type/,
    'Invalid --smalt_mapper_l throws an error'
);

done_testing();


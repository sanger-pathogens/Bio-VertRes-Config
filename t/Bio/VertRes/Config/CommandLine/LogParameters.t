#!/usr/bin/env perl
use strict;
use warnings;
use Data::Dumper;
use File::Temp;
use File::Slurp;
BEGIN { unshift( @INC, './lib' ) }

BEGIN {
    use Test::Most;
    use_ok('Bio::VertRes::Config::CommandLine::LogParameters');
}

my $destination_directory_obj = File::Temp->newdir( CLEANUP => 1 );
my $destination_directory = $destination_directory_obj->dirname();

ok(
    (
        Bio::VertRes::Config::CommandLine::LogParameters->new(
            args     => [ 'a', 'b', 'c' ],
            log_file => $destination_directory . '/x/y/z/logfile',
            script_name => 'zzz'
        )->create
    ),
    'Add text to the log file'
);

ok(
    (
        Bio::VertRes::Config::CommandLine::LogParameters->new(
            args     => [ 'e', 'f', 'g' ],
            log_file => $destination_directory . '/x/y/z/logfile',
            script_name => 'zzz'
        )->create
    ),
    'Add more text to the log file'
);

ok((-e $destination_directory . '/x/y/z/logfile'), 'log file exists');

my $text = read_file( $destination_directory . '/x/y/z/logfile' );
chomp($text);
is($text, "zzz a b c
zzz e f g", 'content of log file as expected ');


done_testing();


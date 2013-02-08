package TestHelper;

use Moose::Role;
use File::Find;
use Test::Most;
use Data::Dumper;

our @actual_files_found;
sub execute_script_and_check_output
{
  my($script_name, $scripts_and_expected_files) = @_;
  
  for my $script_parameters ( sort keys %$scripts_and_expected_files ) {
      my $destination_directory_obj = File::Temp->newdir( CLEANUP => 1 );
      my $destination_directory = $destination_directory_obj->dirname();
  
      my $full_script =
        './bin/' . $script_name . ' ' . $script_parameters . " -c $destination_directory -l t/data/refs.index";
      system("$full_script >/dev/null 2>&1");
      
      find( { wanted => \&process_file, no_chdir => 1 }, ($destination_directory) );
      my @temp_directory_stripped = map { /$destination_directory\/(.+)/ ? $1 : $_ } sort @actual_files_found;
      my @sorted_directory_stripped = sort(@temp_directory_stripped);
      my @sorted_expected_values = sort(@{$scripts_and_expected_files->{$script_parameters}});
      #print Dumper \@sorted_directory_stripped;
      is_deeply(
          \@sorted_directory_stripped,
          \@sorted_expected_values,
          "files created as expected for $full_script"
      );
      @actual_files_found = ();
  }
}


sub process_file {
    if ( -f $_ ) {
        push( @actual_files_found, $File::Find::name );
    }
}


no Moose;
1;


package Bio::VertRes::Config::CommandLine::ReferenceHandlingRole;

# ABSTRACT: A role to handle references in a command line script

=head1 SYNOPSIS

A role to handle references in a command line script
   with 'Bio::VertRes::Config::CommandLine::ReferenceHandlingRole';
   
   $self->handle_reference_inputs_or_exit($reference_lookup_file, $available_referenes, $reference);

=cut

use Moose::Role;
use Bio::VertRes::Config::References;

sub handle_reference_inputs_or_exit
{
  my($reference_lookup_file, $available_references, $reference) = @_;
  
  my $reference_lookup = Bio::VertRes::Config::References->new( reference_lookup_file => $reference_lookup_file );
  
  if ( defined($available_references) && $available_references ne "" ) {
      print join(
          "\n",
          @{ $reference_lookup->search_for_references($available_references)}
      );
      exit(0);
  }
  elsif( ! $reference_lookup->is_reference_name_valid($reference))
  {
    print $reference_lookup->invalid_reference_message($reference);
    exit(1);
  }
  
  return undef;
}

no Moose;
1;



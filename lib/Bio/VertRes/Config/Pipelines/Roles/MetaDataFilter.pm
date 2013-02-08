package Bio::VertRes::Config::Pipelines::Roles::MetaDataFilter;
# ABSTRACT: Moose Role for dealing with limits meta data filters

=head1 SYNOPSIS

Moose Role for dealing with limits meta data filters, for example by study, species, samples, lanes etc...

   with 'Bio::VertRes::Config::Pipelines::Roles::MetaDataFilter';

=method _escaped_limits

Internal variable containing a hash of arrays with the strings in the array escaped out.

=cut

use Moose::Role;

has 'limits'             => ( is => 'ro', isa => 'HashRef', required => 1 );
has '_escaped_limits'    => ( is => 'ro', isa => 'HashRef', lazy    => 1, builder => '_build__escaped_limits' );

sub _build__escaped_limits
{
  my ($self) = @_;
  my %escaped_limits;
  
  for my $limit_type (keys %{$self->limits}) 
  {
    my @escaped_array_values;
    for my $array_value ( @{$self->limits->{$limit_type}})
    {
      push(@escaped_array_values, (quotemeta $array_value));
    }
    $escaped_limits{$limit_type} = \@escaped_array_values;
  }
  return \%escaped_limits;
}




no Moose;
1;


package Bio::VertRes::Config::Validate::Prefix;

# ABSTRACT: Validates a prefix for use in filenames within the pipeline

=head1 SYNOPSIS

Validates a prefix for use in filenames within the pipeline

   use Bio::VertRes::Config::Validate::Prefix;
   Bio::VertRes::Config::Validate::Prefix
      ->new()
      ->is_valid('abc');

=method is_valid

Check to see if the prefix is valid

=cut

use Moose;

sub is_valid {
    my ( $self, $prefix ) = @_;
    return 0 unless ( defined($prefix) );
    return 0 if ( length($prefix) > 12 );
    return 0 if ( $prefix =~ /[\W]/ );
    return 1;
}

no Moose;
__PACKAGE__->meta->make_immutable;
1;

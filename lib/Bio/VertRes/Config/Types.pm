package Bio::VertRes::Config::Types;

# ABSTRACT: Moose types to use for validation.

=head1 SYNOPSIS

Moose types to use for validation.

=cut

use Moose;
use Moose::Util::TypeConstraints;
use Bio::VertRes::Config::Validate::Prefix;
use Bio::VertRes::Config::Validate::File;

subtype 'Bio::VertRes::Config::Prefix', as 'Str', where { Bio::VertRes::Config::Validate::Prefix->new()->is_valid($_) };


subtype 'Bio::VertRes::Config::File',
  as 'Str',
  where { Bio::VertRes::Config::Validate::File->new()->does_file_exist($_) };

no Moose;
no Moose::Util::TypeConstraints;
__PACKAGE__->meta->make_immutable;
1;

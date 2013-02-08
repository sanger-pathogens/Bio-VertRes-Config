package Bio::VertRes::Config::Pipelines::Roles::MultiplePrefix;
# ABSTRACT: Moose Role for where you want different prefixes to allow you to run the same pipeline multiple times on the same data

=head1 SYNOPSIS

Moose Role for where you want different prefixes to allow you to run the same pipeline multiple times on the same data. For example with mapping, bam improvement, rna seq

   with 'Bio::VertRes::Config::Pipelines::Roles::MultiplePrefix';

=method prefix

Creates a timestamped prefix with a random number at the end to reduce the probablity of collisions.

=cut

use Moose::Role;

override 'prefix' => sub {
  my ($self) = @_;
  join('_',('',time(),int(rand(9999)),''));
};

no Moose;
1;


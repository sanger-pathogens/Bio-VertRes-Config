package Bio::VertRes::Config::Recipes::Roles::Reference;
# ABSTRACT: Attributes for working with references

=head1 SYNOPSIS

Attributes for working with references

   with 'Bio::VertRes::Config::Recipes::Roles::Reference';

=cut

use Moose::Role;

has 'reference'             => ( is => 'ro', isa => 'Str', required => 1 );
has 'reference_lookup_file' => ( is => 'ro', isa => 'Str', required => 1 );

no Moose;
1;



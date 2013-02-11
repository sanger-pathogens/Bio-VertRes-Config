package Bio::VertRes::Config::Pipelines::StampyMapping;

# ABSTRACT: Base class for the Stampy mapper

=head1 SYNOPSIS

Base class for the Stampy mapper
   use Bio::VertRes::Config::Pipelines::StampyMapping;

   my $pipeline = Bio::VertRes::Config::Pipelines::StampyMapping->new(
     database => 'abc',
     reference => 'Staphylococcus_aureus_subsp_aureus_ABC_v1',
     limits => {
       project => ['ABC study'],
       species => ['EFG']
     },

     );
   $pipeline->to_hash();

=cut

use Moose;
extends 'Bio::VertRes::Config::Pipelines::Mapping';

has 'slx_mapper'     => ( is => 'ro', isa => 'Str', default => 'stampy' );
has 'slx_mapper_exe' => ( is => 'ro', isa => 'Str', default => '/software/pathogen/external/apps/usr/local/stampy-1.0.15/stampy.py' );

__PACKAGE__->meta->make_immutable;
no Moose;
1;


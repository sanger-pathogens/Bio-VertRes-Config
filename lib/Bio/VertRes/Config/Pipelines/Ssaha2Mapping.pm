package Bio::VertRes::Config::Pipelines::Ssaha2Mapping;

# ABSTRACT: Base class for the Ssaha2 mapper

=head1 SYNOPSIS

Base class for the Ssaha2 mapper
   use Bio::VertRes::Config::Pipelines::Ssaha2Mapping;

   my $pipeline = Bio::VertRes::Config::Pipelines::Ssaha2Mapping->new(
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

has 'slx_mapper'     => ( is => 'ro', isa => 'Str', default => 'ssaha' );
has 'slx_mapper_exe' => ( is => 'ro', isa => 'Str', default => '/software/pathogen/external/apps/usr/local/ssaha2/ssaha2' );

override 'to_hash' => sub {
    my ($self) = @_;
    my $output_hash = super();

    $output_hash->{data}{'454_mapper'}     = $self->slx_mapper;
    $output_hash->{data}{'454_mapper_exe'} = $self->slx_mapper_exe;

    return $output_hash;
};



__PACKAGE__->meta->make_immutable;
no Moose;
1;


package Bio::VertRes::Config::Pipelines::TophatMapping;

# ABSTRACT: Base class for the Tophat mapper

=head1 SYNOPSIS

Base class for the Tophat mapper
   use Bio::VertRes::Config::Pipelines::TophatMapping;

   my $pipeline = Bio::VertRes::Config::Pipelines::TophatMapping->new(
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

has 'slx_mapper'     => ( is => 'ro', isa => 'Str', default => 'tophat' );
has 'slx_mapper_exe' => ( is => 'ro', isa => 'Str', default => '/software/pathogen/external/apps/usr/local/tophat-2.0.8b.Linux_x86_64/tophat' );
has '_mark_duplicates' => ( is => 'ro', isa => 'Int', default => 0 );
has 'additional_mapper_params' => ( is => 'ro', isa => 'Maybe[Str]' );

override 'to_hash' => sub {
    my ($self) = @_;
    my $output_hash = super();

    $output_hash->{data}{additional_mapper_params} = $self->additional_mapper_params if ( defined( $self->additional_mapper_params ) );

    return $output_hash;
};

__PACKAGE__->meta->make_immutable;
no Moose;
1;


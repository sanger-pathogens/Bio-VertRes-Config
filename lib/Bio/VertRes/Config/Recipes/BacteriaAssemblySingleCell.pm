package Bio::VertRes::Config::Recipes::BacteriaAssemblySingleCell;
# ABSTRACT: Create the assembly and anntation files only, so no reference required, but for it to run you need to have done QC first

=head1 SYNOPSIS

Register and QC a study
   use Bio::VertRes::Config::Recipes::BacteriaAssemblyAndAnnotation;

   my $obj = Bio::VertRes::Config::Recipes::BacteriaAssemblyAndAnnotation->new(
     database => 'abc',
     limits => {project => ['Study ABC']}
     );
   $obj->create;

=cut

use Moose;
extends 'Bio::VertRes::Config::Recipes::Common';
with 'Bio::VertRes::Config::Recipes::Roles::BacteriaRegisterStudy';


has 'assembler'            => ( is => 'ro', isa => 'Str',  default => 'spades' );
has '_error_correct'       => ( is => 'ro', isa => 'Bool', default => 0 );
has '_remove_primers'      => ( is => 'ro', isa => 'Bool', default => 0 );
has '_pipeline_version'    => ( is => 'ro', isa => 'Num',  default => 5.0 );
has '_normalise'           => ( is => 'ro', isa => 'Bool', default => 0 );
has '_kingdom'             => ( is => 'ro', isa => 'Str',  default => "Bacteria" );
has '_single_cell'         => ( is => 'ro', isa => 'Bool', default => 1 );

override '_pipeline_configs' => sub {
    my ($self) = @_;
    my @pipeline_configs;
    $self->add_bacteria_spades_single_cell_assembly_config(\@pipeline_configs);
    $self->add_bacteria_annotate_config(\@pipeline_configs);

    return \@pipeline_configs;
};

__PACKAGE__->meta->make_immutable;
no Moose;
1;


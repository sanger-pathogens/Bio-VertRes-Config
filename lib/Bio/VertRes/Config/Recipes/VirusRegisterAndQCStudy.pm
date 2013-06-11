package Bio::VertRes::Config::Recipes::VirusRegisterAndQCStudy;
# ABSTRACT: Register and QC a study

=head1 SYNOPSIS

Register and QC a study
   use Bio::VertRes::Config::Recipes::VirusRegisterAndQCStudy;
   
   my $obj = Bio::VertRes::Config::Recipes::VirusRegisterAndQCStudy->new( 
     database => 'abc', 
     limits => {project => ['Study ABC']}, 
     reference => 'ABC', 
     reference_lookup_file => '/path/to/refs.index');
   $obj->create;
   
=cut

use Moose;
use Bio::VertRes::Config::Pipelines::QC;
use Bio::VertRes::Config::RegisterStudy;
extends 'Bio::VertRes::Config::Recipes::Common';
with 'Bio::VertRes::Config::Recipes::Roles::VirusRegisterStudy';
with 'Bio::VertRes::Config::Recipes::Roles::Reference';
with 'Bio::VertRes::Config::Recipes::Roles::CreateGlobal';

has 'assembler'            => ( is => 'ro', isa => 'Str',  default => 'spades' );
has '_error_correct'       => ( is => 'ro', isa => 'Bool', default => 1 );
has '_remove_primers'      => ( is => 'ro', isa => 'Bool', default => 1 );
has '_pipeline_version'    => ( is => 'ro', isa => 'Int',  default => 3 );
has '_normalise'           => ( is => 'ro', isa => 'Bool', default => 1 );


override '_pipeline_configs' => sub {
    my ($self) = @_;
    my @pipeline_configs;
    $self->add_virus_qc_config(\@pipeline_configs);
    if($self->assembler eq 'velvet')
    {
        $self->add_virus_velvet_assembly_config(\@pipeline_configs);
    }
    else
    {
        $self->add_virus_spades_assembly_config(\@pipeline_configs);
    }
    $self->add_virus_annotate_config(\@pipeline_configs);

    return \@pipeline_configs;
};

__PACKAGE__->meta->make_immutable;
no Moose;
1;


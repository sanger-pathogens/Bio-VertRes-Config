package Bio::VertRes::Config::Recipes::EukaryotesAssembly;
# ABSTRACT: Create the assemblyfiles only, so no reference required, but for it to run you need to have done QC first

=head1 SYNOPSIS

Create the assembly so no reference required, but for it to run you need to have done QC first
   use Bio::VertRes::Config::Recipes::EukaryotesAssemblyAndAnnotation;

   my $obj = Bio::VertRes::Config::Recipes::EukaryotesAssemblyAndAnnotation->new(
     database => 'abc',
     limits => {project => ['Study ABC']});
   $obj->create;

=cut

use Moose;
extends 'Bio::VertRes::Config::Recipes::Common';
with 'Bio::VertRes::Config::Recipes::Roles::EukaryotesRegisterStudy';

has 'assembler'            => ( is => 'ro', isa => 'Str',  default => 'velvet' );
has '_error_correct'       => ( is => 'ro', isa => 'Bool', default => 1 );
has '_remove_primers'      => ( is => 'ro', isa => 'Bool', default => 0 );
has '_pipeline_version'    => ( is => 'ro', isa => 'Num',  default => 4.0 );
has '_normalise'           => ( is => 'ro', isa => 'Bool', default => 0 );

override '_pipeline_configs' => sub {
    my ($self) = @_;
    my @pipeline_configs;
    if($self->assembler eq 'spades')
    {
       $self->add_eukaryotes_spades_assembly_config(\@pipeline_configs);
    }
    else
    {
       $self->add_eukaryotes_velvet_assembly_config(\@pipeline_configs);
    }

    return \@pipeline_configs;
};

__PACKAGE__->meta->make_immutable;
no Moose;
1;


package Bio::VertRes::Config::CommandLine::RegisterAndQCStudy;

# ABSTRACT: Create config scripts to map helminths

=head1 SYNOPSIS

Create config scripts to map helminths

=cut

use Moose;
use Bio::VertRes::Config::Recipes::RegisterAndQCStudy;
with 'Bio::VertRes::Config::CommandLine::ReferenceHandlingRole';
extends 'Bio::VertRes::Config::CommandLine::Common';


sub run {
    my ($self) = @_;

    ( ( ( defined($self->available_references) && $self->available_references ne "" ) || ( $self->reference && $self->type && $self->id ) )
          && !$self->help ) or die $self->usage_text;

    return if(handle_reference_inputs_or_exit( $self->reference_lookup_file, $self->available_references, $self->reference ) == 1);

    Bio::VertRes::Config::Recipes::RegisterAndQCStudy->new( $self->mapping_parameters )->create();

    $self->retrieving_results_text;
}


sub retrieving_results_text {
    my ($self) = @_;
    "";
}

sub usage_text
{
  my ($self) = @_;
  $self->register_and_qc_usage_text;
}

sub register_and_qc_usage_text {
    my ($self) = @_;
    return <<USAGE;
Usage: register_and_qc_study [options]
Pipeline to map and SNP call bacteria, producing a pseudo genome at the end.

# Search for an available reference
register_and_qc_study -a "Stap"

# Register and QC a study
register_and_qc_study -d pathogen_test_track -t study -i 1234 -r "Staphylococcus_aureus_subsp_aureus_EMRSA15_v1"

# Register and QC a single lane
register_and_qc_study -d pathogen_test_track -t lane -i 1234_5#6 -r "Staphylococcus_aureus_subsp_aureus_EMRSA15_v1"

# Register and QC a file of lanes
register_and_qc_study -d pathogen_test_track -t file -i file_of_lanes -r "Staphylococcus_aureus_subsp_aureus_EMRSA15_v1"

# Register and QC a single species in a study
register_and_qc_study -d pathogen_test_track -t study -i 1234 -r "Staphylococcus_aureus_subsp_aureus_EMRSA15_v1" -s "Staphylococcus aureus"

# This help message
register_and_qc_study -h

USAGE
}



__PACKAGE__->meta->make_immutable;
no Moose;
1;
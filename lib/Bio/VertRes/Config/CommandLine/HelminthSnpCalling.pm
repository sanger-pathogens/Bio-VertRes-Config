package Bio::VertRes::Config::CommandLine::HelminthSnpCalling;

# ABSTRACT: Create config scripts to map and snp call bacteria.

=head1 SYNOPSIS

Create config scripts to map and snp call bacteria.

=cut

use Moose;
use Bio::VertRes::Config::Recipes::EukaryotesSnpCallingUsingBwa;
use Bio::VertRes::Config::Recipes::EukaryotesSnpCallingUsingSmalt;
use Bio::VertRes::Config::Recipes::EukaryotesSnpCallingUsingSsaha2;
use Bio::VertRes::Config::Recipes::EukaryotesSnpCallingUsingStampy;
with 'Bio::VertRes::Config::CommandLine::ReferenceHandlingRole';
extends 'Bio::VertRes::Config::CommandLine::Common';

has 'database'    => ( is => 'rw', isa => 'Str', default => 'pathogen_helminth_track' );

sub run {
    my ($self) = @_;

    ( ( ( defined($self->available_references) && $self->available_references ne "" ) || ( $self->reference && $self->type && $self->id ) )
          && !$self->help ) or die $self->usage_text;

    handle_reference_inputs_or_exit( $self->reference_lookup_file, $self->available_references, $self->reference );

    if ( defined($self->mapper) && $self->mapper eq 'bwa' ) {
        Bio::VertRes::Config::Recipes::EukaryotesSnpCallingUsingBwa->new($self->mapping_parameters )->create();
    }
    elsif ( defined($self->mapper) && $self->mapper eq 'ssaha2' ) {
        Bio::VertRes::Config::Recipes::EukaryotesSnpCallingUsingSsaha2->new($self->mapping_parameters )->create();
    }
    elsif ( defined($self->mapper) && $self->mapper eq 'stampy' ) {
        Bio::VertRes::Config::Recipes::EukaryotesSnpCallingUsingStampy->new( $self->mapping_parameters )->create();
    }
    else {
        Bio::VertRes::Config::Recipes::EukaryotesSnpCallingUsingSmalt->new( $self->mapping_parameters)->create();
    }

    $self->retrieving_results_text;
}


sub retrieving_results_text {
    my ($self) = @_;
    $self->retrieving_snp_calling_results_text;
}

sub usage_text
{
  my ($self) = @_;
  $self->snp_calling_usage_text;
}

sub snp_calling_usage_text {
    my ($self) = @_;
    return <<USAGE;
Usage: helminth_snp_calling [options]
Pipeline to map and SNP call helminth, producing a pseudo genome at the end.

# Search for an available reference
helminth_snp_calling -a "Schisto"

# Map and SNP call a study
helminth_snp_calling -t study -i 1234 -r "Schistosoma_mansoni_v5"

# Map and SNP call a single lane
helminth_snp_calling -t lane -i 1234_5#6 -r "Schistosoma_mansoni_v5"

# Map and SNP call a file of lanes
helminth_snp_calling -t file -i file_of_lanes -r "Schistosoma_mansoni_v5"

# Map and SNP call a single species in a study
helminth_snp_calling -t study -i 1234 -r "Schistosoma_mansoni_v5" -s "Schistosoma mansoni"

# Map and SNP call a study with BWA instead of the default (SMALT)
helminth_snp_calling -t study -i 1234 -r "Schistosoma_mansoni_v5" -m bwa

# This help message
helminth_snp_calling -h

USAGE
}



__PACKAGE__->meta->make_immutable;
no Moose;
1;

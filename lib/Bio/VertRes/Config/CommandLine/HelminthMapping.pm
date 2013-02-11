package Bio::VertRes::Config::CommandLine::HelminthMapping;

# ABSTRACT: Create config scripts to map helminths

=head1 SYNOPSIS

Create config scripts to map helminths

=cut

use Moose;
use Bio::VertRes::Config::Recipes::EukaryotesMappingUsingBwa;
use Bio::VertRes::Config::Recipes::EukaryotesMappingUsingSmalt;
use Bio::VertRes::Config::Recipes::EukaryotesMappingUsingSsaha2;
use Bio::VertRes::Config::Recipes::EukaryotesMappingUsingStampy;
use Bio::VertRes::Config::Recipes::EukaryotesMappingUsingTophat;
with 'Bio::VertRes::Config::CommandLine::ReferenceHandlingRole';
extends 'Bio::VertRes::Config::CommandLine::Common';

has 'database'    => ( is => 'rw', isa => 'Str', default => 'pathogen_helminth_track' );

sub run {
    my ($self) = @_;

    ( ( ( defined($self->available_references) && $self->available_references ne "" ) || ( $self->reference && $self->type && $self->id ) )
          && !$self->help ) or die $self->usage_text;

    handle_reference_inputs_or_exit( $self->reference_lookup_file, $self->available_references, $self->reference );

    if ( defined($self->mapper) && $self->mapper eq 'bwa' ) {
        Bio::VertRes::Config::Recipes::EukaryotesMappingUsingBwa->new($self->mapping_parameters )->create();
    }
    elsif ( defined($self->mapper) && $self->mapper eq 'ssaha2' ) {
        Bio::VertRes::Config::Recipes::EukaryotesMappingUsingSsaha2->new($self->mapping_parameters )->create();
    }
    elsif ( defined($self->mapper) && $self->mapper eq 'stampy' ) {
        Bio::VertRes::Config::Recipes::EukaryotesMappingUsingStampy->new( $self->mapping_parameters )->create();
    }
    elsif ( defined($self->mapper) && $self->mapper eq 'tophat' ) {
        Bio::VertRes::Config::Recipes::EukaryotesMappingUsingTophat->new( $self->mapping_parameters )->create();
    }
    else {
        Bio::VertRes::Config::Recipes::EukaryotesMappingUsingSmalt->new( $self->mapping_parameters)->create();
    }

    $self->retrieving_results_text;
}


sub retrieving_results_text {
    my ($self) = @_;
    $self->retrieving_mapping_results_text;
}

sub usage_text
{
  my ($self) = @_;
  $self->mapping_usage_text;
}

sub mapping_usage_text {
    my ($self) = @_;
    return <<USAGE;
Usage: helminth_mapping [options]
Pipeline for helminths mapping

# Search for an available reference
helminth_mapping -a "Leishmania"

# Map a study
helminth_mapping -t study -i 1234 -r "Leishmania_donovani_21Apr2011"

# Map a single lane
helminth_mapping -t lane -i 1234_5#6 -r "Leishmania_donovani_21Apr2011"

# Map a file of lanes
helminth_mapping -t file -i file_of_lanes -r "Leishmania_donovani_21Apr2011"

# Map a single species in a study
helminth_mapping -t study -i 1234 -r "Leishmania_donovani_21Apr2011" -s "Leishmania donovani"

# Map a study with BWA instead of the default (SMALT)
helminth_mapping -t study -i 1234 -r "Leishmania_donovani_21Apr2011" -m bwa

# This help message
helminth_mapping -h

USAGE
}



__PACKAGE__->meta->make_immutable;
no Moose;
1;
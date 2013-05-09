package Bio::VertRes::Config::CommandLine::VirusMapping;

# ABSTRACT: Create config scripts to map viruses

=head1 SYNOPSIS

Create config scripts to map and snp call viruses.

=cut

use Moose;
use Bio::VertRes::Config::Recipes::VirusMappingUsingBwa;
use Bio::VertRes::Config::Recipes::VirusMappingUsingSmalt;
use Bio::VertRes::Config::Recipes::VirusMappingUsingSsaha2;
use Bio::VertRes::Config::Recipes::VirusMappingUsingStampy;
use Bio::VertRes::Config::Recipes::VirusMappingUsingTophat;
use Bio::VertRes::Config::Recipes::VirusMappingUsingBowtie2;
with 'Bio::VertRes::Config::CommandLine::ReferenceHandlingRole';
extends 'Bio::VertRes::Config::CommandLine::Common';

has 'database'    => ( is => 'rw', isa => 'Str', default => 'pathogen_virus_track' );

sub run {
    my ($self) = @_;

    ( ( ( defined($self->available_references) && $self->available_references ne "" ) || ( $self->reference && $self->type && $self->id ) )
          && !$self->help ) or die $self->usage_text;

    return if(handle_reference_inputs_or_exit( $self->reference_lookup_file, $self->available_references, $self->reference ) == 1);

    if ( defined($self->mapper) && $self->mapper eq 'bwa' ) {
        Bio::VertRes::Config::Recipes::VirusMappingUsingBwa->new($self->mapping_parameters )->create();
    }
    elsif ( defined($self->mapper) && $self->mapper eq 'ssaha2' ) {
        Bio::VertRes::Config::Recipes::VirusMappingUsingSsaha2->new($self->mapping_parameters )->create();
    }
    elsif ( defined($self->mapper) && $self->mapper eq 'stampy' ) {
        Bio::VertRes::Config::Recipes::VirusMappingUsingStampy->new( $self->mapping_parameters )->create();
    }
    elsif ( defined($self->mapper) && $self->mapper eq 'tophat' ) {
        Bio::VertRes::Config::Recipes::VirusMappingUsingTophat->new( $self->mapping_parameters )->create();
    }
    elsif ( defined($self->mapper) && $self->mapper eq 'bowtie2' ) {
        Bio::VertRes::Config::Recipes::VirusMappingUsingBowtie2->new( $self->mapping_parameters )->create();
    }
    else {
        Bio::VertRes::Config::Recipes::VirusMappingUsingSmalt->new( $self->mapping_parameters)->create();
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
Usage: virus_mapping [options]
Pipeline for virus mapping

# Search for an available reference
virus_mapping -a "flu"

# Map a study
virus_mapping -t study -i 1234 -r "Influenzavirus_A_H1N1"

# Map a single lane
virus_mapping -t lane -i 1234_5#6 -r "Influenzavirus_A_H1N1"

# Map a file of lanes
virus_mapping -t file -i file_of_lanes -r "Influenzavirus_A_H1N1"

# Map a single species in a study
virus_mapping -t study -i 1234 -r "Influenzavirus_A_H1N1" -s "Influenzavirus A"

# Use a different mapper. Available are bwa/stampy/smalt/ssaha2/bowtie2/tophat. The default is smalt and ssaha2 is only for 454 data.
virus_mapping -t study -i 1234 -r "Influenzavirus_A_H1N1" -m bwa

# This help message
virus_mapping -h

USAGE
}



__PACKAGE__->meta->make_immutable;
no Moose;
1;
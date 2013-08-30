package Bio::VertRes::Config::CommandLine::EukaryotesMapping;

# ABSTRACT: Create config scripts to map eukaryotes

=head1 SYNOPSIS

Create config scripts to map and snp call eukaryotes.

=cut

use Moose;
use Bio::VertRes::Config::Recipes::EukaryotesMappingUsingBwa;
use Bio::VertRes::Config::Recipes::EukaryotesMappingUsingSmalt;
use Bio::VertRes::Config::Recipes::EukaryotesMappingUsingSsaha2;
use Bio::VertRes::Config::Recipes::EukaryotesMappingUsingStampy;
use Bio::VertRes::Config::Recipes::EukaryotesMappingUsingTophat;
use Bio::VertRes::Config::Recipes::EukaryotesMappingUsingBowtie2;
with 'Bio::VertRes::Config::CommandLine::ReferenceHandlingRole';
extends 'Bio::VertRes::Config::CommandLine::Common';

has 'database'    => ( is => 'rw', isa => 'Str', default => 'pathogen_euk_track' );

sub run {
    my ($self) = @_;

    ( ( ( defined($self->available_references) && $self->available_references ne "" ) || ( $self->reference && $self->type && $self->id ) )
          && !$self->help ) or die $self->usage_text;

    return if(handle_reference_inputs_or_exit( $self->reference_lookup_file, $self->available_references, $self->reference ) == 1);

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
    elsif ( defined($self->mapper) && $self->mapper eq 'bowtie2' ) {
        Bio::VertRes::Config::Recipes::EukaryotesMappingUsingBowtie2->new( $self->mapping_parameters )->create();
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
Usage: eukaryote_mapping [options]
Pipeline for eukaryotes mapping

# Search for an available reference
eukaryote_mapping -a "Leishmania"

# Map a study
eukaryote_mapping -t study -i 1234 -r "Leishmania_donovani_21Apr2011"

# Map a single lane
eukaryote_mapping -t lane -i 1234_5#6 -r "Leishmania_donovani_21Apr2011"

# Map a file of lanes
eukaryote_mapping -t file -i file_of_lanes -r "Leishmania_donovani_21Apr2011"

# Map a single species in a study
eukaryote_mapping -t study -i 1234 -r "Leishmania_donovani_21Apr2011" -s "Leishmania donovani"

# Use a different mapper. Available are bwa/stampy/smalt/ssaha2/bowtie2/tophat. The default is smalt and ssaha2 is only for 454 data.
eukaryote_mapping -t study -i 1234 -r "Leishmania_donovani_21Apr2011" -m bwa

# Vary the parameters for smalt
# Index defaults to '-k 13 -s 2'
# Mapping defaults to '-r 0 -x -y 0.8'
eukaryote_mapping -t study -i 1234 -r "Leishmania_donovani_21Apr2011" --smalt_index_k 13 --smalt_index_s 2 --smalt_mapper_r 0 --smalt_mapper_y 0.8 --smalt_mapper_x

# Set orientation of mate pairs for smalt ('pe', 'mp' or 'pp')
eukaryote_mapping -t study -i 1234 -r "Leishmania_donovani_21Apr2011" --smalt_mapper_l pp

# Map a study in named database specifying location of configs
eukaryote_mapping -t study -i 1234 -r "Leishmania_donovani_21Apr2011" -d my_database -c /path/to/my/configs

# Map a study in named database specifying root and log base directories
eukaryote_mapping -t study -i 1234 -r "Leishmania_donovani_21Apr2011" -d my_database -root /path/to/root -log /path/to/log

# Map a study in named database specifying a file with database connection details
eukaryote_mapping -t study -i 1234 -r "Leishmania_donovani_21Apr2011" -d my_database -db_file /path/to/connect/file

# This help message
eukaryote_mapping -h

USAGE
}



__PACKAGE__->meta->make_immutable;
no Moose;
1;
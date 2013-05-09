package Bio::VertRes::Config::CommandLine::HelminthRnaSeqExpression;

# ABSTRACT: Create config scripts to map and run the rna seq expression pipeline

=head1 SYNOPSIS

Create config scripts to map and run the rna seq expression pipeline

=cut

use Moose;
use Bio::VertRes::Config::Recipes::EukaryotesRnaSeqExpressionUsingBwa;
use Bio::VertRes::Config::Recipes::EukaryotesRnaSeqExpressionUsingSmalt;
use Bio::VertRes::Config::Recipes::EukaryotesRnaSeqExpressionUsingTophat;
use Bio::VertRes::Config::Recipes::EukaryotesRnaSeqExpressionUsingStampy;
use Bio::VertRes::Config::Recipes::EukaryotesRnaSeqExpressionUsingBowtie2;
with 'Bio::VertRes::Config::CommandLine::ReferenceHandlingRole';
extends 'Bio::VertRes::Config::CommandLine::Common';

has 'database'    => ( is => 'rw', isa => 'Str', default => 'pathogen_helminth_track' );
has 'protocol'    => ( is => 'rw', isa => 'Str', default => 'StandardProtocol' );

sub run {
    my ($self) = @_;

    (
        (
                 ( defined( $self->available_references ) && $self->available_references ne "" )
              || ( $self->reference && $self->type && $self->id )
        )
          && !$self->help
    ) or die $self->usage_text;

    return if(handle_reference_inputs_or_exit( $self->reference_lookup_file, $self->available_references, $self->reference ) == 1);

    if ( defined($self->mapper) && $self->mapper eq 'bwa' ) {
        Bio::VertRes::Config::Recipes::EukaryotesRnaSeqExpressionUsingBwa->new( $self->mapping_parameters )->create();
    }
    elsif ( defined($self->mapper) && $self->mapper eq 'smalt' ) {
        Bio::VertRes::Config::Recipes::EukaryotesRnaSeqExpressionUsingSmalt->new( $self->mapping_parameters )->create();
    }
    elsif ( defined($self->mapper) && $self->mapper eq 'stampy' ) {
        Bio::VertRes::Config::Recipes::EukaryotesRnaSeqExpressionUsingStampy->new( $self->mapping_parameters )->create();
    }
    elsif ( defined($self->mapper) && $self->mapper eq 'bowtie2' ) {
        Bio::VertRes::Config::Recipes::EukaryotesRnaSeqExpressionUsingBowtie2->new( $self->mapping_parameters )->create();
    }
    else {
        Bio::VertRes::Config::Recipes::EukaryotesRnaSeqExpressionUsingTophat->new($self->mapping_parameters )->create();
    }

    $self->retrieving_results_text;
}

sub retrieving_results_text {
    my ($self) = @_;
    $self->retrieving_rnaseq_results_text;
}

sub usage_text {
    my ($self) = @_;
    $self->rna_seq_usage_text;
}

sub rna_seq_usage_text {
    my ($self) = @_;
    
    return <<USAGE;
Usage: helminth_rna_seq_expression [options]
Run the RNA seq expression pipeline

# Search for an available reference
helminth_rna_seq_expression -a "Schisto"

# Run over a study
helminth_rna_seq_expression -t study -i 1234 -r "Schistosoma_mansoni_v5"

# Run over a single lane
helminth_rna_seq_expression -t lane -i 1234_5#6 -r "Schistosoma_mansoni_v5"

# Run over a file of lanes
helminth_rna_seq_expression -t file -i file_of_lanes -r "Schistosoma_mansoni_v5"

# Use the Strand Specific Protocol, also known as the Croucher protocol. The default is FRT.
helminth_rna_seq_expression -t study -i 1234 -r "Schistosoma_mansoni_v5" -p "StrandSpecificProtocol"

# Run over a single species in a study
helminth_rna_seq_expression -t study -i 1234 -r "Schistosoma_mansoni_v5" -s "Schistosoma mansoni"

# Use a different mapper. Available are bwa/stampy/smalt/ssaha2/bowtie2/tophat. The default is tophat and ssaha2 is only for 454 data.
eukaryote_rna_seq_expression -t study -i 1234 -r "Schistosoma_mansoni_v5" -m bwa

# Vary the parameters for smalt
# Index defaults to '-k 13 -s 2'
# Mapping defaults to '-r 0 -x -y 0.8'
eukaryote_rna_seq_expression -t study -i 1234 -r "Leishmania_donovani_21Apr2011" --smalt_index_k 13 --smalt_index_s 2 --smalt_mapper_r 0 --smalt_mapper_y 0.8 --smalt_mapper_x

# This help message
helminth_rna_seq_expression -h

USAGE
}



__PACKAGE__->meta->make_immutable;
no Moose;
1;

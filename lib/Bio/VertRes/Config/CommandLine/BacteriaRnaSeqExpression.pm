package Bio::VertRes::Config::CommandLine::BacteriaRnaSeqExpression;

# ABSTRACT: Create config scripts to map and run the rna seq expression pipeline

=head1 SYNOPSIS

Create config scripts to map and run the rna seq expression pipeline

=cut

use Moose;
use Bio::VertRes::Config::Recipes::BacteriaRnaSeqExpressionUsingBwa;
use Bio::VertRes::Config::Recipes::BacteriaRnaSeqExpressionUsingSmalt;
use Bio::VertRes::Config::Recipes::BacteriaRnaSeqExpressionUsingTophat;
use Bio::VertRes::Config::Recipes::BacteriaRnaSeqExpressionUsingStampy;
use Bio::VertRes::Config::Recipes::BacteriaRnaSeqExpressionUsingBowtie2;
with 'Bio::VertRes::Config::CommandLine::ReferenceHandlingRole';
extends 'Bio::VertRes::Config::CommandLine::Common';

has 'tophat_mapper_library_type' =>( is => 'rw', isa => 'Bio::VertRes::Config::TophatLib', default => 'fr-firststrand' );
has 'protocol' =>  ( is => 'rw', isa => 'Str', default => 'StandardProtocol' );

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

    if ( defined($self->mapper) && $self->mapper eq 'smalt' ) {
        Bio::VertRes::Config::Recipes::BacteriaRnaSeqExpressionUsingSmalt->new( $self->mapping_parameters )->create();
    }
    elsif ( defined($self->mapper) && $self->mapper eq 'tophat' ) {
        Bio::VertRes::Config::Recipes::BacteriaRnaSeqExpressionUsingTophat->new( $self->mapping_parameters )->create();
    }
    elsif ( defined($self->mapper) && $self->mapper eq 'stampy' ) {
        Bio::VertRes::Config::Recipes::BacteriaRnaSeqExpressionUsingStampy->new( $self->mapping_parameters )->create();
    }
    elsif ( defined($self->mapper) && $self->mapper eq 'bowtie2' ) {
        Bio::VertRes::Config::Recipes::BacteriaRnaSeqExpressionUsingBowtie2->new( $self->mapping_parameters )->create();
    }
    else {
        Bio::VertRes::Config::Recipes::BacteriaRnaSeqExpressionUsingBwa->new($self->mapping_parameters )->create();
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
Usage: bacteria_rna_seq_expression [options]
Run the RNA seq expression pipeline

# Search for an available reference
bacteria_rna_seq_expression -a "Stap"

# Run over a study
bacteria_rna_seq_expression -t study -i 1234 -r "Staphylococcus_aureus_subsp_aureus_EMRSA15_v1"

# Run over a single lane
bacteria_rna_seq_expression -t lane -i 1234_5#6 -r "Staphylococcus_aureus_subsp_aureus_EMRSA15_v1"

# Run over a file of lanes
bacteria_rna_seq_expression -t file -i file_of_lanes -r "Staphylococcus_aureus_subsp_aureus_EMRSA15_v1"

#  The default is the Standard FRT Protocol. Use the Strand Specific Protocol.
bacteria_rna_seq_expression -t study -i 1234 -r "Staphylococcus_aureus_subsp_aureus_EMRSA15_v1" -p "StrandSpecificProtocol"

# Run over a single species in a study
bacteria_rna_seq_expression -t study -i 1234 -r "Staphylococcus_aureus_subsp_aureus_EMRSA15_v1" -s "Staphylococcus aureus"

# Use a different mapper. Available are bwa/stampy/smalt/ssaha2/bowtie2/tophat. The default is bwa and ssaha2 is only for 454 data.
bacteria_rna_seq_expression -t study -i 1234 -r "Staphylococcus_aureus_subsp_aureus_EMRSA15_v1" -m smalt

#Default parameters for Tophat
#The --library_type parameter defaults to fr-firststrand for rnaseq data. Other options are: fr-unstranded or fr-secondstrand. 
bacteria_rna_seq_expression -t study -i 1234 -r "Staphylococcus_aureus_subsp_aureus_EMRSA15_v1" --tophat_mapper_library_type fr-unstranded

# Run over a study in a named database specifying location of configs
bacteria_rna_seq_expression -t study -i 1234 -r "Staphylococcus_aureus_subsp_aureus_EMRSA15_v1" -d my_database -c /path/to/my/configs

# Run over a study in named database specifying root and log base directories
bacteria_rna_seq_expression -t study -i 1234 -r "Staphylococcus_aureus_subsp_aureus_EMRSA15_v1" -d my_database -root /path/to/root -log /path/to/log

# Run over a study in named database specifying a file with database connection details 
bacteria_rna_seq_expression -t study -i 1234 -r "Staphylococcus_aureus_subsp_aureus_EMRSA15_v1" -d my_database -db_file /path/to/connect/file

# This help message
bacteria_rna_seq_expression -h

USAGE
}



__PACKAGE__->meta->make_immutable;
no Moose;
1;

package Bio::VertRes::Config::CommandLine::VirusSnpCalling;

# ABSTRACT: Create config scripts to map and snp call bacteria.

=head1 SYNOPSIS

Create config scripts to map and snp call bacteria.

=cut

use Moose;
use Bio::VertRes::Config::Recipes::VirusSnpCallingUsingBwa;
use Bio::VertRes::Config::Recipes::VirusSnpCallingUsingSmalt;
use Bio::VertRes::Config::Recipes::VirusSnpCallingUsingSsaha2;
use Bio::VertRes::Config::Recipes::VirusSnpCallingUsingStampy;
use Bio::VertRes::Config::Recipes::VirusSnpCallingUsingBowtie2;
with 'Bio::VertRes::Config::CommandLine::ReferenceHandlingRole';
extends 'Bio::VertRes::Config::CommandLine::Common';

has 'database'    => ( is => 'rw', isa => 'Str', default => 'pathogen_virus_track' );

sub run {
    my ($self) = @_;

    ( ( ( defined($self->available_references) && $self->available_references ne "" ) || ( $self->reference && $self->type && $self->id ) )
          && !$self->help ) or die $self->usage_text;

    handle_reference_inputs_or_exit( $self->reference_lookup_file, $self->available_references, $self->reference );

    if ( defined($self->mapper) && $self->mapper eq 'bwa' ) {
        Bio::VertRes::Config::Recipes::VirusSnpCallingUsingBwa->new($self->mapping_parameters )->create();
    }
    elsif ( defined($self->mapper) && $self->mapper eq 'ssaha2' ) {
        Bio::VertRes::Config::Recipes::VirusSnpCallingUsingSsaha2->new($self->mapping_parameters )->create();
    }
    elsif ( defined($self->mapper) && $self->mapper eq 'stampy' ) {
        Bio::VertRes::Config::Recipes::VirusSnpCallingUsingStampy->new( $self->mapping_parameters )->create();
    }
    elsif ( defined($self->mapper) && $self->mapper eq 'bowtie2' ) {
        Bio::VertRes::Config::Recipes::VirusSnpCallingUsingBowtie2->new( $self->mapping_parameters )->create();
    }
    else {
        Bio::VertRes::Config::Recipes::VirusSnpCallingUsingSmalt->new( $self->mapping_parameters)->create();
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
Usage: virus_snp_calling [options]
Pipeline to map and SNP call viruses, producing a pseudo genome at the end.

# Search for an available reference
virus_snp_calling -a "flu"

# Map and SNP call a study
virus_snp_calling -t study -i 1234 -r "Influenzavirus_A_H1N1"

# Map and SNP call a single lane
virus_snp_calling -t lane -i 1234_5#6 -r "Influenzavirus_A_H1N1"

# Map and SNP call a file of lanes
virus_snp_calling -t file -i file_of_lanes -r "Influenzavirus_A_H1N1"

# Map and SNP call a single species in a study
virus_snp_calling -t study -i 1234 -r "Influenzavirus_A_H1N1" -s "Influenzavirus A"

# Use a different mapper. Available are bwa/stampy/smalt/ssaha2/bowtie2. The default is smalt and ssaha2 is only for 454 data.
virus_snp_calling -t study -i 1234 -r "Influenzavirus_A_H1N1" -m bwa

# This help message
virus_snp_calling -h

USAGE
}



__PACKAGE__->meta->make_immutable;
no Moose;
1;

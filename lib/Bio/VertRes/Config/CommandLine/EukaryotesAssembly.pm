package Bio::VertRes::Config::CommandLine::EukaryotesAssembly;

# ABSTRACT: Create assembly files

=head1 SYNOPSIS

Create assembly files, but QC and store must have been run first, avoids the need for a reference

=cut

use Moose;
use Bio::VertRes::Config::Recipes::EukaryotesAssembly;
extends 'Bio::VertRes::Config::CommandLine::Common';

has 'database'  => ( is => 'rw', isa => 'Str', default => 'pathogen_euk_track' );

sub run {
    my ($self) = @_;

    ($self->type && $self->id  && !$self->help ) or die $self->usage_text;

    my %mapping_parameters = %{$self->mapping_parameters};
    $mapping_parameters{'assembler'} = $self->assembler if defined ($self->assembler);
    Bio::VertRes::Config::Recipes::EukaryotesAssembly->new( \%mapping_parameters )->create();

    $self->retrieving_results_text;
};

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
Usage: eukaryote_assembly [options]
Pipeline to run assembly and annotation. Study must be registered and QC'd separately first

# Register and QC a study
eukaryote_assembly -t study -i 1234 

# Register and QC a single lane
eukaryote_assembly -t lane -i 1234_5#6 

# Register and QC a file of lanes
eukaryote_assembly -t file -i file_of_lanes 

# Register and QC a single species in a study
eukaryote_assembly -t study -i 1234  -s "Staphylococcus aureus"

# Register and QC a study assembling with SPAdes
eukaryote_assembly -t study -i 1234 -assembler spades

# Register and QC a study in named database specifying location of configs
eukaryote_assembly -t study -i 1234  -d my_database -c /path/to/my/configs

# This help message
eukaryote_assembly -h

USAGE
};



__PACKAGE__->meta->make_immutable;
no Moose;
1;
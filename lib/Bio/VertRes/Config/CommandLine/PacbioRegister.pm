package Bio::VertRes::Config::CommandLine::PacbioRegister;

# ABSTRACT: Create config scripts to assemble and annotate Pacbio data

=head1 SYNOPSIS

Create config scripts to assemble and annotate pacbio data

=cut

use Moose;
use Bio::VertRes::Config::Recipes::PacbioRegister;
with 'Bio::VertRes::Config::CommandLine::ReferenceHandlingRole';
extends 'Bio::VertRes::Config::CommandLine::Common';

has 'database'  => ( is => 'rw', isa => 'Str', default => 'pathogen_pacbio_track' );

sub run {
    my ($self) = @_;
    
    (($self->type && $self->id)  && !$self->help ) or die $self->usage_text;

    (!$self->help) or die $self->usage_text;

    #return if(handle_reference_inputs_or_exit( $self->reference_lookup_file, $self->available_references, $self->reference ) == 1);
    
    my %mapping_parameters = %{$self->mapping_parameters};
    $mapping_parameters{'_genome_size'} = $self->genome_size if defined ($self->genome_size);
    $mapping_parameters{'circularise'} = $self->circularise if defined ($self->circularise);
    $mapping_parameters{'annotate'} = $self->annotate if defined ($self->annotate);
    Bio::VertRes::Config::Recipes::PacbioRegister->new( \%mapping_parameters )->create();

    $self->retrieving_results_text;
};

sub retrieving_results_text {
    my ($self) = @_;
    print "Your request was SUCCESSFUL\n\n";
    print "Once the data is available you can run these commands:\n\n";

    print "Create symlinks to the raw PacBio read data and final assemblies\n";
    print "  pf data -t " . $self->type ." -i " . $self->id . " --filetype pacbio --symlink\n\n";
    print "  pf assembly -t " . $self->type . " -i " . $self->id . " --symlink\n\n";

    print "Create symlinks to final assembly annotations\n";
    print "  pf annotation -t " . $self->type . " -i " . $self->id . " --symlink\n\n";

    print "Generate a report of the assembly statistics in CSV format\n";
    print "  pf assembly -t " . $self->type . " -i " . $self->id . " --stats\n\n";

    print "More details\n";
    print "  pf data -h\n";
    print "  pf assembly -h\n";
    print "  pf annotation -h\n\n";

    print "NOTE - If you are uncertain that your request was successful, please do NOT run the command again. Instead, please direct any queries to path-help\@sanger.ac.uk.\n\n";
    print "If you use the results of this pipeline, please acknowledge the pathogen informatics team and include the appropriate citations for the pipeline. For more information on how to cite this pipeline, please see:\n";
    print "http://mediawiki.internal.sanger.ac.uk/index.php/Pathogen_Informatics_Pipelines_-_Methods\n";
}

sub usage_text
{
  my ($self) = @_;
  $self->register_usage_text;
}

sub register_usage_text {
    my ($self) = @_;
    return <<USAGE;
Usage: pacbio_register -t <ID type> -i <ID> [options]
Pipeline to register a pacbio study.

Required:
  -t        STR Type (study/lane/file)
  -i        STR Study name, study ID, lane, file of lanes

Options:
  --genome_size     Genome size [default=4500000]
  --no_circularise  Do not circularise
  --no_annotation   Do not annotate assembly
  -h                Print this message and exit

NOTE - If you are uncertain that your request was successful, please do NOT run the command again. Instead, please direct any queries to path-help\@sanger.ac.uk.

If you use the results of this pipeline, please acknowledge the pathogen informatics team and include the appropriate citations for the pipeline. For more information on how to cite this pipeline, please see:
http://mediawiki.internal.sanger.ac.uk/index.php/Pathogen_Informatics_Pipelines_-_Methods#PacBio_Assembly_and_Annotation

For more information about the assembly and annotation pipeline, please see:
http://mediawiki.internal.sanger.ac.uk/index.php/Pathogen_Informatics_Automated_PacBio_Assembly_Pipeline

USAGE
};



__PACKAGE__->meta->make_immutable;
no Moose;
1;

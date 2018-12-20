package Bio::VertRes::Config::CommandLine::BacteriaRegisterAndQCStudy;

# ABSTRACT: Create config scripts to register and QC bacteria

=head1 SYNOPSIS

Create config scripts to register and QC bacteria

=cut

use Moose;
use Bio::VertRes::Config::Recipes::BacteriaRegisterAndQCStudy;
with 'Bio::VertRes::Config::CommandLine::ReferenceHandlingRole';
extends 'Bio::VertRes::Config::CommandLine::Common';

has 'database'  => ( is => 'rw', isa => 'Str', default => 'pathogen_prok_track' );

sub run {
    my ($self) = @_;

    ( ( ( defined($self->available_references) && $self->available_references ne "" ) || ( $self->reference && $self->type && $self->id ) )
          && !$self->help ) or die $self->usage_text;

    return if(handle_reference_inputs_or_exit( $self->reference_lookup_file, $self->available_references, $self->reference ) == 1);

    my %mapping_parameters = %{$self->mapping_parameters};
    $mapping_parameters{'assembler'} = $self->assembler if defined ($self->assembler);
    $mapping_parameters{'no_ass'} = defined($self->no_ass);
    $mapping_parameters{'iva_qc'} = $self->iva_qc if defined ($self->iva_qc);
    $mapping_parameters{'kraken_db'} = $self->kraken_db if defined ($self->kraken_db);
    Bio::VertRes::Config::Recipes::BacteriaRegisterAndQCStudy->new( \%mapping_parameters )->create();

    $self->retrieving_results_text;
};

sub retrieving_results_text {
    my ($self) = @_;
    print "Your request was SUCCESSFUL\n\n";
    print "Once the data is available you can run these commands:\n\n";

    print "Create symlinks to the fastq files, final assemblies and annotations\n";
    print "  pf data -t " . $self->type ." -i " . $self->id . " --filetype fastq --symlink\n\n";
    print "  pf assembly -t " . $self->type . " -i " . $self->id . " --symlink\n\n";
    print "  pf annotation -t " . $self->type . " -i " . $self->id . " --symlink\n\n";

    print "Return the Kraken report(s) from the QC pipeline";
    print "  pf qc -t " . $self->type ." -i " . $self->id . "\n\n";

    print "Generate a report of the assembly statistics in CSV format\n";
    print "  pf assembly -t " . $self->type . " -i " . $self->id . " --stats\n\n";

    print "More details\n";
    print "  pf data -h\n";
    print "  pf qc -h\n";
    print "  pf assembly -h\n";
    print "  pf annotation -h\n\n";

    print "NOTE - If you are uncertain that your request was successful, please do NOT run the command again. Instead, please direct any queries to path-help\@sanger.ac.uk.\n\n";
    print "If you use the results of this pipeline, please acknowledge the pathogen informatics team and include the appropriate citations for the pipeline. For more information on how to cite this pipeline, please see:\n";
    print "http://mediawiki.internal.sanger.ac.uk/index.php/Pathogen_Informatics_Pipelines_-_Methods\n";
}

sub usage_text
{
  my ($self) = @_;
  $self->register_and_qc_usage_text;
}

sub register_and_qc_usage_text {
    my ($self) = @_;
    return <<USAGE;
Usage: bacteria_register_and_qc_study -t <ID type> -i <ID> -r <reference> [options]
Pipeline to register, QC, assemble and annotate a bacteria study.

Required: 
  -t            STR Type (study/lane/file)
  -i            STR Study name, study ID, lane, file of lanes
  -r            STR Reference to QC against. Must match exactly one of the references from the -a option.
	  
Options:
  -s            STR Limit to a single species name (e.g. 'Staphylococcus aureus')	 
  --assembler   STR Set a different assembler (spades/velvet/iva) [velvet]
  --spades_opts STR Modify parameters sent to SPAdes. Only --careful and --cov-cutoff auto are available. Default is none.
  --no_aa           Dont assemble or annotate
  -d            STR Specify a database [pathogen_prok_track]
  -c            STR Base directory to config files [/nfs/pathnfs05/conf]
  --root        STR Base directory for the pipelines [/lustre/scratch118/infgen/pathogen/pathpipe]
  --log         STR Base directory for the log files [/nfs/pathnfs05/log]
  --db_file     STR Filename containing database connection details [/software/pathogen/config/database_connection_details]
  -a            STR Search for available reference matching pattern and exit.  
  -h                Print this message and exit

NOTE - If you are uncertain that your request was successful, please do NOT run the command again. Instead, please direct any queries to path-help\@sanger.ac.uk.

If you use the results of these pipelines, please acknowledge the pathogen informatics team and include the appropriate citations:

"Robust high throughput prokaryote de novo assembly and improvement pipeline for Illumina data"
Page AJ, De Silva, N., Hunt M, Quail MA, Parkhill J, Harris SR, Otto TD, Keane JA. (2016). Microbial Genomics 2(8) doi: 10.1099/mgen.0.000083 

For more information on how to site the pipelines, please see:
http://mediawiki.internal.sanger.ac.uk/index.php/Pathogen_Informatics_Pipelines_-_Methods#Bacterial_Assembly_and_Annotation

For example usage and more information about the QC, assembly and annotation pipelines, please see:
http://mediawiki.internal.sanger.ac.uk/index.php/Pathogen_Informatics_Pipelines#QC_Pipeline
http://mediawiki.internal.sanger.ac.uk/index.php/Assembly_Pipeline_-_Pathogen_Informatics
http://mediawiki.internal.sanger.ac.uk/index.php/Pathogen_Informatics_Automated_Annotation_Pipeline

USAGE
};



__PACKAGE__->meta->make_immutable;
no Moose;
1;

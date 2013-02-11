package Bio::VertRes::Config::CommandLine::Common;

# ABSTRACT: Create config scripts

=head1 SYNOPSIS

Create config scripts

=cut

use Moose;
use Getopt::Long qw(GetOptionsFromArray);
use Bio::VertRes::Config::CommandLine::LogParameters;
use Bio::VertRes::Config::CommandLine::ConstructLimits;

has 'args'        => ( is => 'ro', isa => 'ArrayRef', required => 1 );
has 'script_name' => ( is => 'ro', isa => 'Str',      required => 1 );

has 'database'    => ( is => 'rw', isa => 'Str', default => 'pathogen_prok_track' );
has 'config_base' => ( is => 'rw', isa => 'Str', default => '/nfs/pathnfs01/conf' );
has 'reference_lookup_file' =>  ( is => 'rw', isa => 'Str', default => '/lustre/scratch108/pathogen/pathpipe/refs/refs.index' );
has 'reference'                      => ( is => 'rw', isa => 'Maybe[Str]', );
has 'available_references'           => ( is => 'rw', isa => 'Maybe[Str]' );
has 'type'                           => ( is => 'rw', isa => 'Maybe[Str]' );
has 'id'                             => ( is => 'rw', isa => 'Maybe[Str]' );
has 'species'                        => ( is => 'rw', isa => 'Maybe[Str]' );
has 'mapper'                         => ( is => 'rw', isa => 'Maybe[Str]' );
has 'protocol'                       => ( is => 'rw', isa => 'Str', default => 'StrandSpecificProtocol' );
has 'regeneration_log_file'          => ( is => 'rw', isa => 'Maybe[Str]' );
has 'overwrite_existing_config_file' => ( is => 'rw', isa => 'Bool', default => 0 );
has 'help'                           => ( is => 'rw', isa => 'Bool', default => 0 );

sub BUILD {
    my ($self) = @_;
    my $log_params =
      Bio::VertRes::Config::CommandLine::LogParameters->new( args => $self->args, script_name => $self->script_name );

    my ( $database, $config_base, $reference_lookup_file, $available_references, $reference, $type, $id, $species,
        $mapper, $regeneration_log_file, $overwrite_existing_config_file, $protocol, $help );

    GetOptionsFromArray(
        $self->args,
        'd|database=s'                     => \$database,
        'c|config_base=s'                  => \$config_base,
        'l|reference_lookup_file=s'        => \$reference_lookup_file,
        'r|reference=s'                    => \$reference,
        'a|available_references=s'         => \$available_references,
        't|type=s'                         => \$type,
        'i|id=s'                           => \$id,
        's|species=s'                      => \$species,
        'm|mapper=s'                       => \$mapper,
        'b|regeneration_log_file=s'        => \$regeneration_log_file,
        'o|overwrite_existing_config_file' => \$overwrite_existing_config_file,
        'p|protocol=s'                     => \$protocol,
        'h|help'                           => \$help,
    );

    $self->database($database)                           if ( defined($database) );
    $self->config_base($config_base)                     if ( defined($config_base) );
    $self->reference_lookup_file($reference_lookup_file) if ( defined($reference_lookup_file) );
    $self->reference($reference)                         if ( defined($reference) );
    $self->available_references($available_references)   if ( defined($available_references) );
    $self->type($type)                                   if ( defined($type) );
    $self->id($id)                                       if ( defined($id) );
    $self->species($species)                             if ( defined($species) );
    $self->mapper($mapper)                               if ( defined($mapper) );
    $self->protocol($protocol)                           if ( defined($protocol) );
    $self->help($help)                                   if ( defined($help) );

    $regeneration_log_file ||= join( '/', ( $self->config_base, 'command_line.log' ) );
    $self->regeneration_log_file($regeneration_log_file) if ( defined($regeneration_log_file) );
    $self->overwrite_existing_config_file($overwrite_existing_config_file)
      if ( defined($overwrite_existing_config_file) );

    $log_params->log_file($self->regeneration_log_file);
    $log_params->create();
}

sub mapping_parameters
{
  my ($self) = @_;
  my $limits = Bio::VertRes::Config::CommandLine::ConstructLimits->new(
      input_type => $self->type,
      input_id   => $self->id,
      species    => $self->species
  )->limits_hash;

  my %mapping_parameters = (
      database                       => $self->database,
      config_base                    => $self->config_base,
      limits                         => $limits,
      reference_lookup_file          => $self->reference_lookup_file,
      reference                      => $self->reference,
      overwrite_existing_config_file => $self->overwrite_existing_config_file,
      protocol                       => $self->protocol
  );
  
  return \%mapping_parameters;
}



# Overwrite this method
sub retrieving_results_text {
    my ($self) = @_;
}

# Overwrite this method
sub usage_text
{
  my ($self) = @_;
}


sub retrieving_rnaseq_results_text
{
  my ($self) = @_;
  print "Once the data is available you can run these commands:\n\n";
  
  print "Create symlinks to all your data\n";
  print "  rnaseqfind -t ".$self->type." -i ".$self->id." -symlink\n\n";
  
  print "Symlink to the spreadsheets of statistics per gene\n";
  print "  rnaseqfind -t ".$self->type." -i ".$self->id." -symlink -f spreadsheet\n\n";
  
  print "Symlink to the BAM files (corrected for the protocol)\n";
  print "  rnaseqfind -t ".$self->type." -i ".$self->id." -symlink -f bam\n\n";
  
  print "Symlink to the annotation for the intergenic regions\n";
  print "  rnaseqfind -t ".$self->type." -i ".$self->id." -symlink -f intergenic\n\n";
  
  print "Symlink to the coverage plots\n";
  print "  rnaseqfind -t ".$self->type." -i ".$self->id." -symlink -f coverage\n\n";
  
  print "More details\n";
  print "  rnaseqfind -h\n";
}


sub retrieving_mapping_results_text
{
  my ($self) = @_;
  print "Once the data is available you can run these commands:\n\n";

  print "Symlink to the BAM files\n";
  print "  mapfind -t ".$self->type." -i ".$self->id." -symlink\n\n";

  print "Find out which mapper and reference was used\n";
  print "  mapfind -t ".$self->type." -i ".$self->id." -d\n\n";

  print "More details\n";
  print "  mapfind -h\n\n";
}

sub retrieving_snp_calling_results_text
{
  my ($self) = @_;
  print "Once the data is available you can run these commands:\n\n";
  
  print "Create a multifasta alignment file of your data\n";
  print "  snpfind -t ".$self->type." -i ".$self->id." -p \n\n";
  
  print "Create symlinks to the unfiltered variants in VCF format\n";
  print "  snpfind -t ".$self->type." -i ".$self->id." -symlink\n\n";
  
  print "Symlink to the BAM files\n";
  print "  mapfind -t ".$self->type." -i ".$self->id." -symlink\n\n";
  
  print "More details\n";
  print "  snpfind -h\n";
  print "  mapfind -h\n\n";
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;

package Bio::VertRes::Config::Pipelines::AnnotateAssembly;

# ABSTRACT: A class for generating the AnnotateAssembly pipeline config file which annotates an assembly

=head1 SYNOPSIS

A class for generating the AnnotateAssembly pipeline config file
   use Bio::VertRes::Config::Pipelines::AnnotateAssembly;
   
   my $pipeline = Bio::VertRes::Config::Pipelines::AnnotateAssembly->new(database    => 'abc'
                                                                         config_base => '/path/to/config/base',
                                                                         limits      => { project => ['project name'] });
   $pipeline->to_hash();

=cut

use Moose;
use Bio::VertRes::Config::Pipelines::Common;
use Bio::VertRes::Config::Pipelines::Roles::MetaDataFilter;
extends 'Bio::VertRes::Config::Pipelines::Common';
with 'Bio::VertRes::Config::Pipelines::Roles::MetaDataFilter';

has 'pipeline_short_name'  => ( is => 'ro', isa => 'Str', default => 'annotate_assembly' );
has 'module'               => ( is => 'ro', isa => 'Str', default => 'VertRes::Pipelines::AnnotateAssembly' );
has 'prefix'               => ( is => 'ro', isa => 'Bio::VertRes::Config::Prefix', default => '_annotate_' );
has 'toplevel_action'      => ( is => 'ro', isa => 'Str', default => '__VRTrack_AnnotateAssembly__' );

has '_max_failures'        => ( is => 'ro', isa => 'Int', default => 3 );
has '_max_lanes_to_search' => ( is => 'ro', isa => 'Int', default => 1000 );
has '_limit'               => ( is => 'ro', isa => 'Int', default => 100 );
has '_tmp_directory'       => ( is => 'ro', isa => 'Str', default => '/lustre/scratch108/pathogen/pathpipe/tmp' );
has '_assembler'           => ( is => 'ro', isa => 'Str', default => 'velvet' );
has '_annotation_tool'     => ( is => 'ro', isa => 'Str', default => 'Prokka' );
has '_dbdir'               => ( is => 'ro', isa => 'Str', default => '/lustre/scratch108/pathogen/pathpipe/prokka' );
has '_pipeline_version'    => ( is => 'ro', isa => 'Int', default => 1 );
has '_memory_in_mb'        => ( is => 'ro', isa => 'Int', default => 3000 );

override 'to_hash' => sub {
    my ($self) = @_;
    my $output_hash = super();
    $output_hash->{limit}                   = $self->_limit;
    $output_hash->{max_lanes_to_search}     = $self->_max_lanes_to_search;
    $output_hash->{max_failures}            = $self->_max_failures;
    $output_hash->{vrtrack_processed_flags} = { assembled => 1, annotated => 0 };
    $output_hash->{limits}                  = $self->_escaped_limits;

    $output_hash->{data}{tmp_directory}     = $self->_tmp_directory;
    $output_hash->{data}{assembler}         = $self->_assembler;
    $output_hash->{data}{annotation_tool}   = $self->_annotation_tool;
    $output_hash->{data}{dbdir}             = $self->_dbdir;
    $output_hash->{data}{pipeline_version}  = $self->_pipeline_version;
    $output_hash->{data}{memory}            = $self->_memory_in_mb;
    
    return $output_hash;
};

sub _construct_filename
{
  my ($self, $suffix) = @_;
  my $output_filename = $self->_limits_values_part_of_filename();
  return $self->_filter_characters_truncate_and_add_suffix($output_filename,$suffix);
}

override 'log_file_name' => sub {
    my ($self) = @_;
    return $self->_construct_filename('log');
};

override 'config_file_name' => sub {
    my ($self) = @_;
    return $self->_construct_filename('conf');
};


__PACKAGE__->meta->make_immutable;
no Moose;
1;

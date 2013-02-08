package Bio::VertRes::Config::Pipelines::Assembly;

# ABSTRACT: A class for generating the Assembly pipeline config file which archives data to nfs units

=head1 SYNOPSIS

A class for generating the Assembly pipeline config file
   use Bio::VertRes::Config::Pipelines::Assembly;
   
   my $pipeline = Bio::VertRes::Config::Pipelines::Assembly->new(database => 'abc');
   $pipeline->to_hash();

=cut

use Moose;
use Bio::VertRes::Config::Pipelines::Common;
extends 'Bio::VertRes::Config::Pipelines::Common';

has 'pipeline_short_name'  => ( is => 'ro', isa => 'Str', default => 'assembly' );
has 'module'               => ( is => 'ro', isa => 'Str', default => 'VertRes::Pipelines::Assembly' );
has 'prefix'               => ( is => 'ro', isa => 'Bio::VertRes::Config::Prefix', default => '_assembly_' );
has 'toplevel_action'      => ( is => 'ro', isa => 'Str', default => '__VRTrack_Assembly__' );

has '_max_failures'        => ( is => 'ro', isa => 'Int', default => 3 );
has '_max_lanes_to_search' => ( is => 'ro', isa => 'Int', default => 200 );
has '_limit'               => ( is => 'ro', isa => 'Int', default => 100 );
has '_tmp_directory'       => ( is => 'ro', isa => 'Str', default => '/lustre/scratch108/pathogen/pathpipe/tmp' );
has '_genome_size'         => ( is => 'ro', isa => 'Int', default => 10000000 );
has '_assembler'           => ( is => 'ro', isa => 'Str', default => 'velvet' );
has '_assembler_exec'      => ( is => 'ro', isa => 'Str', default => '/software/pathogen/external/apps/usr/bin/velvet' );
has '_optimiser_exec'      => ( is => 'ro', isa => 'Str', default => '/software/pathogen/external/apps/usr/bin/VelvetOptimiser.pl' );
has '_max_threads'         => ( is => 'ro', isa => 'Int', default => 1 );

override 'to_hash' => sub {
    my ($self) = @_;
    my $output_hash = super();
    $output_hash->{limit}                   = $self->_limit;
    $output_hash->{max_lanes_to_search}     = $self->_max_lanes_to_search;
    $output_hash->{max_failures}            = $self->_max_failures;
    $output_hash->{vrtrack_processed_flags} = { stored => 1, assembled => 0, rna_seq_expression => 0 };

    $output_hash->{data}{tmp_directory} = $self->_tmp_directory;

    # rough guess at the maximum you expect to get
    $output_hash->{data}{genome_size}       = $self->_genome_size;
    $output_hash->{data}{seq_pipeline_root} = $self->root;
    $output_hash->{data}{assembler}         = $self->_assembler;
    $output_hash->{data}{assembler_exec}    = $self->_assembler_exec;
    $output_hash->{data}{optimiser_exec}    = $self->_optimiser_exec;
    $output_hash->{data}{max_threads}       = $self->_max_threads;

    return $output_hash;
};

__PACKAGE__->meta->make_immutable;
no Moose;
1;

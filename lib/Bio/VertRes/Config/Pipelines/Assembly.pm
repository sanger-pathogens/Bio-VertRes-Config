package Bio::VertRes::Config::Pipelines::Assembly;

# ABSTRACT: A base class for generating the Assembly pipeline config file which archives data to nfs units

=head1 SYNOPSIS

A base class for generating the Assembly pipeline config file
   use Bio::VertRes::Config::Pipelines::Assembly;

   my $pipeline = Bio::VertRes::Config::Pipelines::Assembly->new(database    => 'abc'
                                                                 config_base => '/path/to/config/base',
                                                                 limits      => { project => ['project name']);
   $pipeline->to_hash();

=cut

use Moose;
use Bio::VertRes::Config::Pipelines::Common;
extends 'Bio::VertRes::Config::Pipelines::Common';
with 'Bio::VertRes::Config::Pipelines::Roles::MetaDataFilter';

has 'pipeline_short_name'  => ( is => 'ro', isa => 'Str', default => 'assembly' );
has 'module'               => ( is => 'ro', isa => 'Str', default => 'VertRes::Pipelines::Assembly' );
has 'prefix'               => ( is => 'ro', isa => 'Bio::VertRes::Config::Prefix', default => '_assembly_' );
has 'toplevel_action'      => ( is => 'ro', isa => 'Str', default => '__VRTrack_Assembly__' );

has '_max_failures'        => ( is => 'ro', isa => 'Int', default => 3 );
has '_max_lanes_to_search' => ( is => 'ro', isa => 'Int', default => 10000 );
has '_limit'               => ( is => 'ro', isa => 'Int', default => 100000 );
has '_tmp_directory'       => ( is => 'ro', isa => 'Str', default => '/lustre/scratch118/infgen/pathogen/pathpipe/tmp' );
has '_genome_size'         => ( is => 'ro', isa => 'Int', default => 10000000 );
has '_assembler'           => ( is => 'ro', isa => 'Str', default => 'velvet' );
has '_assembler_exec'      => ( is => 'ro', isa => 'Str', default => '/software/pathogen/external/apps/usr/bin/velvet' );
has '_optimiser_exec'      => ( is => 'ro', isa => 'Str', default => '/software/pathogen/external/apps/usr/bin/VelvetOptimiser.pl' );
has '_max_threads'         => ( is => 'ro', isa => 'Int', default => 1 );
has '_error_correct'       => ( is => 'ro', isa => 'Bool', default => 0 );
has '_sga_exec'            => ( is => 'ro', isa => 'Str', default => '/software/pathogen/external/apps/usr/bin/sga' );
has '_normalise'           => ( is => 'ro', isa => 'Bool', default => 0 );
has '_post_contig_filtering' => ( is => 'ro', isa => 'Int', default => 300 );
has '_primers_file'        => ( is => 'ro', isa => 'Str',  default => '/lustre/scratch118/infgen/pathogen/pathpipe/usr/share/solexa-adapters.quasr' );
has '_remove_primers'      => ( is => 'ro', isa => 'Bool', default => 0 );
has '_improve_assembly'    => ( is => 'ro', isa => 'Bool', lazy_build => 1 );

has 'iva_qc'			   => ( is => 'ro', isa => 'Bool', default => 0 );
has 'kraken_db'		   => ( is => 'ro', isa => 'Str',  default => '/lustre/scratch118/infgen/pathogen/pathpipe/kraken/assemblyqc_fluhiv_20150728' );

has '_vrtrack_processed_flags'    => ( is => 'ro', isa => 'HashRef', default => sub {{ qc => 1, rna_seq_expression => 0 }} );

has '_subversions' => ( is => 'rw', isa => 'HashRef', lazy_build => 1 );

sub _build__subversions {
    my %subversions = ( 
        '0000'  => '.0.0',
        '00000' => '.0.0',
        '1110'  => '.1.0',
        '1100'  => '.2.0',
        '1010'  => '.3.0',
        '0110'  => '.4.0',
        '1000'  => '.5.0',
        '0100'  => '.6.0',
        '0010'  => '.7.0',
        '0001'  => '.0.1',
        '1111'  => '.1.1',
        '1101'  => '.2.1',
        '1011'  => '.3.1',
        '0111'  => '.4.1',
        '1001'  => '.5.1',
        '0101'  => '.6.1',
        '0011'  => '.7.1',
        '00101' => '.8.0',
    );
    return \%subversions;
}

sub _build__improve_assembly {
    my $self = shift;
    return (defined $self->_optimiser_exec) ? 1 : 0;
}

override 'to_hash' => sub {
    my ($self) = @_;
    my $output_hash = super();

    $output_hash->{limit}                   = $self->_limit;
    $output_hash->{max_lanes_to_search}     = $self->_max_lanes_to_search;
    $output_hash->{max_failures}            = $self->_max_failures;
    $output_hash->{vrtrack_processed_flags} = $self->_vrtrack_processed_flags;
    $output_hash->{limits}                  = $self->_escaped_limits;
    $output_hash->{data}{tmp_directory}     = $self->_tmp_directory;

    # rough guess at the maximum you expect to get
    $output_hash->{data}{genome_size}       = $self->_genome_size;
    $output_hash->{data}{seq_pipeline_root} = $self->root;
    $output_hash->{data}{assembler}         = $self->_assembler;
    $output_hash->{data}{assembler_exec}    = $self->_assembler_exec;
    $output_hash->{data}{optimiser_exec}    = $self->_optimiser_exec;
    $output_hash->{data}{max_threads}       = $self->_max_threads;
    $output_hash->{data}{error_correct}     = $self->_error_correct;
    $output_hash->{data}{sga_exec}          = $self->_sga_exec;
    $output_hash->{data}{normalise}         = $self->_normalise;
    $output_hash->{data}{post_contig_filtering} = $self->_post_contig_filtering;
    $output_hash->{data}{improve_assembly}  = $self->_improve_assembly;

    # Remove primers
    $output_hash->{data}{primers_file}   = $self->_primers_file;
    $output_hash->{data}{remove_primers} = $self->_remove_primers;
    
    # iva_qc
	$output_hash->{data}{iva_qc}   = $self->iva_qc;
    $output_hash->{data}{kraken_db} = $self->kraken_db;    

    return $output_hash;
};

sub _construct_filename
{
  my ($self, $suffix) = @_;
  my $output_filename = join('_',($self->_limits_values_part_of_filename(),$self->_assembler));
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

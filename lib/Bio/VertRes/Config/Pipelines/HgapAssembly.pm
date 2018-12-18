package Bio::VertRes::Config::Pipelines::HgapAssembly;

# ABSTRACT: A base class for generating an Assembly pipeline config file using hgap

=head1 SYNOPSIS

A class for generating the Assembly pipeline config file using the hgap assembler
   use Bio::VertRes::Config::Pipelines::HgapAssembly;
   
   my $pipeline = Bio::VertRes::Config::Pipelines::HgapAssembly->new(database    => 'abc'
                                                                       config_base => '/path/to/config/base',
                                                                       limits      => { project => ['project name']);
   $pipeline->to_hash();

=cut

use Moose;
extends 'Bio::VertRes::Config::Pipelines::Assembly';

has 'pipeline_short_name'  => ( is => 'ro', isa => 'Str', default => 'assembly' );
has 'prefix'               => ( is => 'ro', isa => 'Bio::VertRes::Config::Prefix', default => '_pacbio_' );
has 'module'               => ( is => 'ro', isa => 'Str', default => 'VertRes::Pipelines::PacbioAssembly' );
has '_assembler'           => ( is => 'ro', isa => 'Str',  default => 'hgap' );
has '_assembler_exec'      => ( is => 'ro', isa => 'Str',  default => '/software/pathogen/internal/prod/bin/pacbio_assemble_smrtanalysis' );
has '_improve_assembly'    => ( is => 'ro', isa => 'Bool', default => 0 );
has '_optimiser_exec'      => ( is => 'ro', isa => 'Str', default => '' );
has 'kraken_db'		   	   => ( is => 'ro', isa => 'Str',  default => '' ); # not relevant at the moment
has '_primers_file'        => ( is => 'ro', isa => 'Str',  default => '' ); # not relevant
has '_threads'         => ( is => 'ro', isa => 'Int',  default => 12 );
has '_queue'			   => ( is => 'ro', isa => 'Str', default => 'normal');
has '_genome_size'         => ( is => 'ro', isa => 'Int', default => 7000000 );
has '_memory'         	   => ( is => 'ro', isa => 'Int', default => 60000 );
has '_target_coverage'	   => ( is => 'ro', isa => 'Int', default => 30 );
has '_no_bsub'			   => ( is => 'ro', isa => 'Bool', default => 1 );
has 'circularise'		   => ( is => 'ro', isa => 'Bool', default => 0 );

has '_vrtrack_processed_flags'    => ( is => 'ro', isa => 'HashRef', default => sub {{ import => 1, assembled => 0 }} );

has '_pipeline_version'    => ( is => 'rw', isa => 'Str',  lazy_build => 1 );
has '_flag'                => ( is => 'ro', isa => 'Str',  lazy_build => 1 );


sub _build__flag {
    my $self = shift;
    my $flag = $self->_error_correct . 
               $self->_normalise .
               $self->_remove_primers .
               $self->_improve_assembly;
    return $flag;
}

sub _build__pipeline_version {
    my $self = shift;
    my %subversions = %{ $self->_subversions };

    my $version = '8' . $subversions{$self->_flag};
    $self->_pipeline_version($version);
}


override 'to_hash' => sub {
  my ($self) = @_;
  my $output_hash = super();

	$output_hash->{data}{module} = $self->module;
	$output_hash->{data}{pipeline_version} = $self->_pipeline_version;
  $output_hash->{data}{queue} = $self->_queue;
  $output_hash->{data}{memory} = $self->_memory;
  $output_hash->{data}{target_coverage} = $self->_target_coverage;
  $output_hash->{data}{no_bsub} = $self->_no_bsub;
  $output_hash->{data}{genome_size} = $self->_genome_size;
  $output_hash->{data}{circularise} = $self->circularise;
  $output_hash->{data}{threads} = $self->_threads;

    return $output_hash;
};


__PACKAGE__->meta->make_immutable;
no Moose;
1;

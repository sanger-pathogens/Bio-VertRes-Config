package Bio::VertRes::Config::Pipelines::VelvetAssembly;

# ABSTRACT: A base class for generating an Assembly pipeline config file using velvet

=head1 SYNOPSIS

A class for generating the Assembly pipeline config file using the velvet assembler
   use Bio::VertRes::Config::Pipelines::VelvetAssembly;
   
   my $pipeline = Bio::VertRes::Config::Pipelines::VelvetAssembly->new(database    => 'abc'
                                                                       config_base => '/path/to/config/base',
                                                                       limits      => { project => ['project name']);
   $pipeline->to_hash();

=cut


use Moose;
extends 'Bio::VertRes::Config::Pipelines::Assembly';

has '_assembler'           => ( is => 'ro', isa => 'Str', default => 'velvet' );
has 'prefix'               => ( is => 'ro', isa => 'Bio::VertRes::Config::Prefix', default => '_velvet_' );
has '_assembler_exec'      => ( is => 'ro', isa => 'Str', default => '/software/pathogen/external/apps/usr/bin/velvet' );
has '_optimiser_exec'      => ( is => 'ro', isa => 'Str', default => '/software/pathogen/external/apps/usr/bin/VelvetOptimiser.pl' );
has '_max_threads'         => ( is => 'ro', isa => 'Int', default => 2 );

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

    my $version = '2' . $subversions{$self->_flag};
    $self->_pipeline_version($version);
}

override 'to_hash' => sub {
    my ($self) = @_;

    my $output_hash = super();

    $output_hash->{data}{pipeline_version} = $self->_pipeline_version;

    return $output_hash;
};

__PACKAGE__->meta->make_immutable;
no Moose;
1;

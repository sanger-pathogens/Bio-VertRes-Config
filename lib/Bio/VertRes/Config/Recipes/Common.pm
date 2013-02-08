package Bio::VertRes::Config::Recipes::Common;

# ABSTRACT: Common base for recipes

=head1 SYNOPSIS

Common base for recipes
   use Bio::VertRes::Config::Recipes::Common;
   extends 'Bio::VertRes::Config::Recipes::Common';

=cut

use Moose;
use Bio::VertRes::Config::MultipleTopLevelFiles;

has 'database'                       => ( is => 'ro', isa => 'Str',  required => 1 );
has 'config_base'                    => ( is => 'ro', isa => 'Str',  default  => '/nfs/pathnfs01/conf' );
has 'overwrite_existing_config_file' => ( is => 'ro', isa => 'Bool', default  => 0 );
has 'limits'                         => ( is => 'ro', isa => 'HashRef', default => sub { {} });

has '_pipeline_configs'              => ( is => 'ro', isa => 'ArrayRef', default => sub { [] });

sub create {
    my ($self) = @_;

    my $top_level = Bio::VertRes::Config::MultipleTopLevelFiles->new(
        database            => $self->database,
        pipeline_configs    => $self->_pipeline_configs,
        config_base => $self->config_base
    );
    $top_level->update_or_create();

    return $self;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;

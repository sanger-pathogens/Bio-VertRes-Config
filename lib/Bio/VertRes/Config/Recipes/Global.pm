package Bio::VertRes::Config::Recipes::Global;

# ABSTRACT: Setting up global config files

=head1 SYNOPSIS

Setting up global config files. Done once per database
   use Bio::VertRes::Config::Recipes::Global;
   
   my $obj = Bio::VertRes::Config::Recipes::Global->new( database => 'abc' );
   $obj->create;
   
=cut

use Moose;
use Bio::VertRes::Config::Pipelines::Assembly;
use Bio::VertRes::Config::Pipelines::Import;
use Bio::VertRes::Config::Pipelines::Store;
extends 'Bio::VertRes::Config::Recipes::Common';

override '_pipeline_configs' => sub {
    my ($self) = @_;
    my @pipeline_configs;
    push(
        @pipeline_configs,
        Bio::VertRes::Config::Pipelines::Assembly->new(
            database                       => $self->database,
            config_base                    => $self->config_base,
            overwrite_existing_config_file => $self->overwrite_existing_config_file
        )
    );
    push(
        @pipeline_configs,
        Bio::VertRes::Config::Pipelines::Import->new(
            database                       => $self->database,
            config_base                    => $self->config_base,
            overwrite_existing_config_file => $self->overwrite_existing_config_file
        )
    );
    push(
        @pipeline_configs,
        Bio::VertRes::Config::Pipelines::Store->new(
            database                       => $self->database,
            config_base                    => $self->config_base,
            overwrite_existing_config_file => $self->overwrite_existing_config_file
        )
    );
    return \@pipeline_configs;
};

__PACKAGE__->meta->make_immutable;
no Moose;
1;

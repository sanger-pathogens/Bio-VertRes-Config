package Bio::VertRes::Config::Recipes::Roles::EukaryotesMapping;
# ABSTRACT: Moose Role which creates the Euk mapping  objects

=head1 SYNOPSIS

Moose Role which creates the Euk mapping  objects

   with 'Bio::VertRes::Config::Recipes::Roles::EukaryotesMapping';


=method add_eukaryotes_bwa_mapping_config

create the mapping config for bwa

=cut

use Moose::Role;
use Bio::VertRes::Config::Pipelines::BwaMapping;
use Bio::VertRes::Config::Pipelines::Ssaha2Mapping;
use Bio::VertRes::Config::Pipelines::StampyMapping;
use Bio::VertRes::Config::Pipelines::TophatMapping;
use Bio::VertRes::Config::Pipelines::Bowtie2Mapping;

sub add_eukaryotes_bwa_mapping_config
{
  my ($self, $pipeline_configs_array) = @_;
  push(
      @{$pipeline_configs_array},
      Bio::VertRes::Config::Pipelines::BwaMapping->new(
          database                       => $self->database,
          database_connect_file          => $self->database_connect_file,
          config_base                    => $self->config_base,
          root_base                      => $self->root_base,
          log_base                       => $self->log_base,
          overwrite_existing_config_file => $self->overwrite_existing_config_file,
          limits                         => $self->limits,
          reference                      => $self->reference,
          reference_lookup_file          => $self->reference_lookup_file,
      )
  );
  return ;
}

sub add_eukaryotes_bowtie2_mapping_config
{
  my ($self, $pipeline_configs_array) = @_;
  push(
      @{$pipeline_configs_array},
          Bio::VertRes::Config::Pipelines::Bowtie2Mapping->new(
              database                       => $self->database,
              database_connect_file          => $self->database_connect_file,
              config_base                    => $self->config_base,
              root_base                      => $self->root_base,
              log_base                       => $self->log_base,
              overwrite_existing_config_file => $self->overwrite_existing_config_file,
              limits                         => $self->limits,
              reference                      => $self->reference,
              reference_lookup_file          => $self->reference_lookup_file,

          )
      );
  return ;
}


sub add_eukaryotes_ssaha2_mapping_config
{
  my ($self, $pipeline_configs_array) = @_;
  push(
      @{$pipeline_configs_array},
          Bio::VertRes::Config::Pipelines::Ssaha2Mapping->new(
              database                       => $self->database,
              database_connect_file          => $self->database_connect_file,
              config_base                    => $self->config_base,
              root_base                      => $self->root_base,
              log_base                       => $self->log_base,
              overwrite_existing_config_file => $self->overwrite_existing_config_file,
              limits                         => $self->limits,
              reference                      => $self->reference,
              reference_lookup_file          => $self->reference_lookup_file,

          )
      );
  return ;
}

sub add_eukaryotes_tophat_mapping_config
{
  my ($self, $pipeline_configs_array) = @_;
  push(
      @{$pipeline_configs_array},
    Bio::VertRes::Config::Pipelines::TophatMapping->new(
        database                       => $self->database,
        database_connect_file          => $self->database_connect_file,
        config_base                    => $self->config_base,
        root_base                      => $self->root_base,
        log_base                       => $self->log_base,
        overwrite_existing_config_file => $self->overwrite_existing_config_file,
        limits                         => $self->limits,
        reference                      => $self->reference,
        reference_lookup_file          => $self->reference_lookup_file,
        additional_mapper_params       => $self->additional_mapper_params,
          )
      );
  return ;
}


sub add_eukaryotes_stampy_mapping_config
{
  my ($self, $pipeline_configs_array) = @_;
  push(
      @{$pipeline_configs_array},
          Bio::VertRes::Config::Pipelines::StampyMapping->new(
              database                       => $self->database,
              database_connect_file          => $self->database_connect_file,
              config_base                    => $self->config_base,
              root_base                      => $self->root_base,
              log_base                       => $self->log_base,
              overwrite_existing_config_file => $self->overwrite_existing_config_file,
              limits                         => $self->limits,
              reference                      => $self->reference,
              reference_lookup_file          => $self->reference_lookup_file,

          )
      );
  return ;
}


no Moose;
1;



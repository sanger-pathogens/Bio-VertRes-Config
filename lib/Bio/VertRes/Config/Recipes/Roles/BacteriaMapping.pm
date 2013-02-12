package Bio::VertRes::Config::Recipes::Roles::BacteriaMapping;
# ABSTRACT: Moose Role which creates the Euk mapping  objects

=head1 SYNOPSIS

Moose Role which creates the Euk mapping  objects

   with 'Bio::VertRes::Config::Recipes::Roles::BacteriaMapping';


=method add_bacteria_bwa_mapping_config

create the mapping config for bwa

=cut

use Moose::Role;
use Bio::VertRes::Config::Pipelines::BwaMapping;
use Bio::VertRes::Config::Pipelines::Ssaha2Mapping;
use Bio::VertRes::Config::Pipelines::StampyMapping;
use Bio::VertRes::Config::Pipelines::TophatMapping;
use Bio::VertRes::Config::Pipelines::SmaltMapping;
use Bio::VertRes::Config::Pipelines::Bowtie2Mapping;

sub add_bacteria_bwa_mapping_config
{
  my ($self, $pipeline_configs_array) = @_;
  push(
      @{$pipeline_configs_array},
      Bio::VertRes::Config::Pipelines::BwaMapping->new(
          database                       => $self->database,
          config_base                    => $self->config_base,
          overwrite_existing_config_file => $self->overwrite_existing_config_file,
          limits                         => $self->limits,
          reference                      => $self->reference,
          reference_lookup_file          => $self->reference_lookup_file,
      )
  );
  return ;
}


sub add_bacteria_ssaha2_mapping_config
{
  my ($self, $pipeline_configs_array) = @_;
  push(
      @{$pipeline_configs_array},
          Bio::VertRes::Config::Pipelines::Ssaha2Mapping->new(
              database                       => $self->database,
              config_base                    => $self->config_base,
              overwrite_existing_config_file => $self->overwrite_existing_config_file,
              limits                         => $self->limits,
              reference                      => $self->reference,
              reference_lookup_file          => $self->reference_lookup_file,

          )
      );
  return ;
}

sub add_bacteria_tophat_mapping_config
{
  my ($self, $pipeline_configs_array) = @_;
  push(
      @{$pipeline_configs_array},
    Bio::VertRes::Config::Pipelines::TophatMapping->new(
        database                       => $self->database,
        config_base                    => $self->config_base,
        overwrite_existing_config_file => $self->overwrite_existing_config_file,
        limits                         => $self->limits,
        reference                      => $self->reference,
        reference_lookup_file          => $self->reference_lookup_file
          )
      );
  return ;
}



sub add_bacteria_smalt_mapping_config
{
  my ($self, $pipeline_configs_array) = @_;
  push(
      @{$pipeline_configs_array},
          Bio::VertRes::Config::Pipelines::SmaltMapping->new(
              database                       => $self->database,
              config_base                    => $self->config_base,
              overwrite_existing_config_file => $self->overwrite_existing_config_file,
              limits                         => $self->limits,
              reference                      => $self->reference,
              reference_lookup_file          => $self->reference_lookup_file,
              additional_mapper_params       => $self->additional_mapper_params,
              mapper_index_params            => $self->mapper_index_params
          )
      );
  return ;
}


sub add_bacteria_stampy_mapping_config
{
  my ($self, $pipeline_configs_array) = @_;
  push(
      @{$pipeline_configs_array},
          Bio::VertRes::Config::Pipelines::StampyMapping->new(
              database                       => $self->database,
              config_base                    => $self->config_base,
              overwrite_existing_config_file => $self->overwrite_existing_config_file,
              limits                         => $self->limits,
              reference                      => $self->reference,
              reference_lookup_file          => $self->reference_lookup_file,

          )
      );
  return ;
}

sub add_bacteria_bowtie2_mapping_config
{
  my ($self, $pipeline_configs_array) = @_;
  push(
      @{$pipeline_configs_array},
          Bio::VertRes::Config::Pipelines::Bowtie2Mapping->new(
              database                       => $self->database,
              config_base                    => $self->config_base,
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



package Bio::VertRes::Config::Recipes::Roles::BacteriaRegisterStudy;
# ABSTRACT: Moose Role for registering a study

=head1 SYNOPSIS

Moose Role for registering a study

   with 'Bio::VertRes::Config::Recipes::Roles::RegisterStudy';

=method create

Hooks into the create method after the base method is run to register a study

=method add_qc_config

Method with takes in the pipeline config array and adds the qc config to it.

=cut

use Moose::Role;
use Bio::VertRes::Config::Pipelines::QC;
use Bio::VertRes::Config::Pipelines::VelvetAssembly;
use Bio::VertRes::Config::Pipelines::SpadesAssembly;
use Bio::VertRes::Config::Pipelines::AnnotateAssembly;
use Bio::VertRes::Config::RegisterStudy;

# Register all the studies passed in the project limits array
after 'create' => sub {
  my ($self) = @_;
  
  if(defined($self->limits->{project}))
  {
    for my $study_name ( @{$self->limits->{project}} )
    {
      my $pipeline = Bio::VertRes::Config::RegisterStudy->new(
        database    => $self->database,
        study_name  => $study_name,
        config_base => $self->config_base
      );
      $pipeline->register_study_name();
    }
  }
};

sub add_bacteria_qc_config
{
  my ($self, $pipeline_configs_array) = @_;
  push(
      @{$pipeline_configs_array},
      Bio::VertRes::Config::Pipelines::QC->new(
          database                       => $self->database,
          database_connect_file          => $self->database_connect_file,
          config_base                    => $self->config_base,
          root_base                      => $self->root_base,
          log_base                       => $self->log_base,
          overwrite_existing_config_file => $self->overwrite_existing_config_file,
          limits                         => $self->limits,
          reference                      => $self->reference,
          reference_lookup_file          => $self->reference_lookup_file
      )
  );
  return ;
}

sub add_bacteria_velvet_assembly_config
{
  my ($self, $pipeline_configs_array) = @_;
  push(
      @{$pipeline_configs_array},
      Bio::VertRes::Config::Pipelines::VelvetAssembly->new(
          database                       => $self->database,
          database_connect_file          => $self->database_connect_file,
          config_base                    => $self->config_base,
          root_base                      => $self->root_base,
          log_base                       => $self->log_base,
          overwrite_existing_config_file => $self->overwrite_existing_config_file,
          limits                         => $self->limits,
          _error_correct                 => $self->_error_correct,
          _remove_primers                => $self->_remove_primers,
          _pipeline_version              => $self->_pipeline_version,
          _normalise                     => $self->_normalise
      )
  );
  return ;
}

sub add_bacteria_spades_single_cell_assembly_config
{
  my ($self, $pipeline_configs_array) = @_;
  push(
      @{$pipeline_configs_array},
      Bio::VertRes::Config::Pipelines::SpadesAssembly->new(
          database                       => $self->database,
          database_connect_file          => $self->database_connect_file,
          config_base                    => $self->config_base,
          root_base                      => $self->root_base,
          log_base                       => $self->log_base,
          overwrite_existing_config_file => $self->overwrite_existing_config_file,
          limits                         => $self->limits,
          _error_correct                 => $self->_error_correct,
          _remove_primers                => $self->_remove_primers,
          _pipeline_version              => $self->_pipeline_version,
          _normalise                     => $self->_normalise,
          _single_cell                   => $self->_single_cell,
      )
  );
  return ;
}

sub add_bacteria_spades_assembly_config
{
  my ($self, $pipeline_configs_array) = @_;
  push(
      @{$pipeline_configs_array},
      Bio::VertRes::Config::Pipelines::SpadesAssembly->new(
          database                       => $self->database,
          database_connect_file          => $self->database_connect_file,
          config_base                    => $self->config_base,
          root_base                      => $self->root_base,
          log_base                       => $self->log_base,
          overwrite_existing_config_file => $self->overwrite_existing_config_file,
          limits                         => $self->limits,
          _error_correct                 => $self->_error_correct,
          _remove_primers                => $self->_remove_primers,
          _pipeline_version              => $self->_pipeline_version,
          _normalise                     => $self->_normalise
      )
  );
  return ;
}

sub add_bacteria_annotate_config
{
  my ($self, $pipeline_configs_array) = @_;
  push(
      @{$pipeline_configs_array},
      Bio::VertRes::Config::Pipelines::AnnotateAssembly->new(
          database                       => $self->database,
          database_connect_file          => $self->database_connect_file,
          root_base                      => $self->root_base,
          log_base                       => $self->log_base,
          config_base                    => $self->config_base,
          overwrite_existing_config_file => $self->overwrite_existing_config_file,
          limits                         => $self->limits,
          _kingdom                       => $self->_kingdom,
          _assembler                     => $self->assembler,
      )
  );
  return ;
}


no Moose;
1;



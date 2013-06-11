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

has '_project_limits' => ( is => 'ro', isa => 'HashRef', lazy_build => 1 ); 

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
          config_base                    => $self->config_base,
          overwrite_existing_config_file => $self->overwrite_existing_config_file,
          limits                         => $self->limits,
          reference                      => $self->reference,
          reference_lookup_file          => $self->reference_lookup_file
      )
  );
  return ;
}

sub _build__project_limits
{
    my ($self) = @_;
    my %project_limits;
    $project_limits{project} = $self->limits->{project} if defined($self->limits->{project});
    return \%project_limits;
}

sub add_bacteria_velvet_assembly_config
{
  my ($self, $pipeline_configs_array) = @_;
  push(
      @{$pipeline_configs_array},
      Bio::VertRes::Config::Pipelines::VelvetAssembly->new(
          database                       => $self->database,
          config_base                    => $self->config_base,
          overwrite_existing_config_file => $self->overwrite_existing_config_file,
          limits                         => $self->_project_limits,
          _error_correct                 => $self->_error_correct,
          _remove_primers                => $self->_remove_primers,
          _pipeline_version              => $self->_pipeline_version, 
          _normalise                     => $self->_normalise 
      )
  ) if defined($self->limits->{project});
  return ;
}

sub add_bacteria_spades_assembly_config
{
  my ($self, $pipeline_configs_array) = @_;
  push(
      @{$pipeline_configs_array},
      Bio::VertRes::Config::Pipelines::SpadesAssembly->new(
          database                       => $self->database,
          config_base                    => $self->config_base,
          overwrite_existing_config_file => $self->overwrite_existing_config_file,
          limits                         => $self->_project_limits,
          _error_correct                 => $self->_error_correct,
          _remove_primers                => $self->_remove_primers,
          _pipeline_version              => $self->_pipeline_version, 
          _normalise                     => $self->_normalise 
      )
  ) if defined($self->limits->{project});
  return ;
}

sub add_bacteria_annotate_config
{
  my ($self, $pipeline_configs_array) = @_;
  push(
      @{$pipeline_configs_array},
      Bio::VertRes::Config::Pipelines::AnnotateAssembly->new(
          database                       => $self->database,
          config_base                    => $self->config_base,
          overwrite_existing_config_file => $self->overwrite_existing_config_file,
          limits                         => $self->_project_limits
      )
  ) if defined($self->limits->{project});
  return ;
}


no Moose;
1;



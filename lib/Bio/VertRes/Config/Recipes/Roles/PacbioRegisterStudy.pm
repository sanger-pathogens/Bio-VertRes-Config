package Bio::VertRes::Config::Recipes::Roles::PacbioRegisterStudy;
# ABSTRACT: Moose Role for registering a pacbio study

=head1 SYNOPSIS

Moose Role for registering a pacbio study

   with 'Bio::VertRes::Config::Recipes::Roles::PacbioRegisterStudy';

=method create

Hooks into the create method after the base method is run to register a study

=method 

=cut

use Moose::Role;
use Bio::VertRes::Config::Pipelines::HgapAssembly;
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

sub add_hgap_assembly_config
{
  my ($self, $pipeline_configs_array) = @_;
  push(
      @{$pipeline_configs_array},
      Bio::VertRes::Config::Pipelines::HgapAssembly->new(
          database                       => $self->database,
          database_connect_file          => $self->database_connect_file,
          config_base                    => $self->config_base,
          root_base                      => $self->root_base,
          log_base                       => $self->log_base,
          overwrite_existing_config_file => $self->overwrite_existing_config_file,
          limits                         => $self->limits,
          _queue						 => $self->_queue,
          _memory						 => $self->_memory,
          _target_coverage			     => $self->_target_coverage,
          _no_bsub						 => $self->_no_bsub,
          circularise					 => $self->circularise,
          _genome_size         => $self->_genome_size,
 
      )
  );
  return ;
}


sub add_bacteria_annotate_config
{
  my ($self, $pipeline_configs_array) = @_;
  
  for my $assembler_alias (@{$self->assembler_alias_for_annotation})
  {
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
            _assembler                     => $assembler_alias,
            _memory_in_mb				   => $self->_memory_in_mb,
        )
    );
  }
  return ;
}


no Moose;
1;



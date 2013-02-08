package Bio::VertRes::Config::Recipes::Roles::RegisterStudy;
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

sub add_qc_config
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


no Moose;
1;



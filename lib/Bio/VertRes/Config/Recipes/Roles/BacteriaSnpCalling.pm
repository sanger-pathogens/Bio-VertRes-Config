package Bio::VertRes::Config::Recipes::Roles::BacteriaSnpCalling;
# ABSTRACT: Moose Role which creates the bacteria snp calling object

=head1 SYNOPSIS

Moose Role which creates the bacteria snp calling object

   with 'Bio::VertRes::Config::Recipes::Roles::BacteriaSnpCalling';


=method add_bacteria_snp_calling_config

Method with takes in the pipeline config array and adds the bacteria snp calling config to it.

=cut

use Moose::Role;
use Bio::VertRes::Config::Pipelines::SnpCalling;

sub add_bacteria_snp_calling_config
{
  my ($self, $pipeline_configs_array) = @_;
  push(
      @{$pipeline_configs_array},
      Bio::VertRes::Config::Pipelines::SnpCalling->new(
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


no Moose;
1;



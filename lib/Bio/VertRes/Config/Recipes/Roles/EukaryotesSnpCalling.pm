package Bio::VertRes::Config::Recipes::Roles::EukaryotesSnpCalling;
# ABSTRACT: Moose Role which creates the bacteria snp calling object

=head1 SYNOPSIS

Moose Role which creates the bacteria snp calling object

   with 'Bio::VertRes::Config::Recipes::Roles::EukaryotesSnpCalling';


=method add_eukaryotes_snp_calling_config

Method with takes in the pipeline config array and adds the euk snp calling config to it.

=cut

use Moose::Role;
use Bio::VertRes::Config::Pipelines::SnpCalling;

sub add_eukaryotes_snp_calling_config
{
  my ($self, $pipeline_configs_array) = @_;
  push(
      @{$pipeline_configs_array},
      Bio::VertRes::Config::Pipelines::SnpCalling->new(
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


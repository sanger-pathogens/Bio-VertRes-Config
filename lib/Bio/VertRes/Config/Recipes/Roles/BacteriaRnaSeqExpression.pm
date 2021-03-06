package Bio::VertRes::Config::Recipes::Roles::BacteriaRnaSeqExpression;
# ABSTRACT: Moose Role which creates the rna seq expression object

=head1 SYNOPSIS

Moose Role which creates the rna seq expression object

   with 'Bio::VertRes::Config::Recipes::Roles::BacteriaRnaSeqExpression';


=method add_rna_seq_expression_config

Method with takes in the pipeline config array and adds the rna seq expression config to it.

=cut

use Moose::Role;
use Bio::VertRes::Config::Pipelines::RnaSeqExpression;

sub add_bacteria_rna_seq_expression_config
{
  my ($self, $pipeline_configs_array) = @_;
  push(
      @{$pipeline_configs_array},
      Bio::VertRes::Config::Pipelines::RnaSeqExpression->new(
          database                       => $self->database,
          database_connect_file          => $self->database_connect_file,
          config_base                    => $self->config_base,
          root_base                      => $self->root_base,
          log_base                       => $self->log_base,
          overwrite_existing_config_file => $self->overwrite_existing_config_file,
          limits                         => $self->limits,
          reference                      => $self->reference,
          reference_lookup_file          => $self->reference_lookup_file,
          protocol                       => $self->protocol,
          _intergenic_regions            => $self->_intergenic_regions,
          _no_coverage_plots             => $self->_no_coverage_plots,
          _sequencing_file_suffix        => $self->_sequencing_file_suffix
      )
  );
  return ;
}


no Moose;
1;



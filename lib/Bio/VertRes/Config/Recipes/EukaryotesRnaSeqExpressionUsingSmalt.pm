package Bio::VertRes::Config::Recipes::EukaryotesRnaSeqExpressionUsingSmalt;
# ABSTRACT: Standard snp calling pipeline for bacteria

=head1 SYNOPSIS

RNA seq expression with SMALT
   use Bio::VertRes::Config::Recipes::EukaryotesRnaSeqExpressionUsingSmalt;
   
   my $obj = Bio::VertRes::Config::Recipes::EukaryotesRnaSeqExpressionUsingSmalt->new( 
     database => 'abc', 
     limits => {project => ['Study ABC']}, 
     reference => 'ABC', 
     reference_lookup_file => '/path/to/refs.index',
     additional_mapper_params => '',
     mapper_index_params => '',
     protocol => 'StrandSpecificProtocol'
     );
   $obj->create;
   
=cut

use Moose;
use Bio::VertRes::Config::Pipelines::QC;
use Bio::VertRes::Config::Pipelines::SmaltMapping;
use Bio::VertRes::Config::Pipelines::RnaSeqExpression;
use Bio::VertRes::Config::RegisterStudy;
extends 'Bio::VertRes::Config::Recipes::Common';
with 'Bio::VertRes::Config::Recipes::Roles::RegisterStudy';
with 'Bio::VertRes::Config::Recipes::Roles::Reference';
with 'Bio::VertRes::Config::Recipes::Roles::CreateGlobal';
with 'Bio::VertRes::Config::Recipes::Roles::EukaryotesRnaSeqExpression';

has 'protocol'  => ( is => 'ro', isa => 'Str',  default => 'StrandSpecificProtocol' );

has 'additional_mapper_params' => ( is => 'ro', isa => 'Str', default => '-r 0 -x -y 0.8');
has 'mapper_index_params'      => ( is => 'ro', isa => 'Str', default => '-k 13 -s 2' );

override '_pipeline_configs' => sub {
    my ($self) = @_;
    my @pipeline_configs;
    
    $self->add_qc_config(\@pipeline_configs);
    
    push(
        @pipeline_configs,
        Bio::VertRes::Config::Pipelines::SmaltMapping->new(
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
            mapper_index_params            => $self->mapper_index_params
        )
    );
    
    $self->add_eukaryotes_rna_seq_expression_config(\@pipeline_configs);
    
    return \@pipeline_configs;
};

__PACKAGE__->meta->make_immutable;
no Moose;
1;


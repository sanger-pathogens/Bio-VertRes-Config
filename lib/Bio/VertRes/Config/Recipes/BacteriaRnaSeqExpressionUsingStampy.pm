package Bio::VertRes::Config::Recipes::BacteriaRnaSeqExpressionUsingStampy;
# ABSTRACT: Standard snp calling pipeline for bacteria

=head1 SYNOPSIS

RNA seq expression with Stampy
   use Bio::VertRes::Config::Recipes::BacteriaRnaSeqExpressionUsingStampy;
   
   my $obj = Bio::VertRes::Config::Recipes::BacteriaRnaSeqExpressionUsingStampy->new( 
     database => 'abc', 
     limits => {project => ['Study ABC']}, 
     reference => 'ABC', 
     reference_lookup_file => '/path/to/refs.index',
     );
   $obj->create;
   
=cut

use Moose;
use Bio::VertRes::Config::Pipelines::QC;
use Bio::VertRes::Config::Pipelines::StampyMapping;
use Bio::VertRes::Config::Pipelines::RnaSeqExpression;
use Bio::VertRes::Config::RegisterStudy;
extends 'Bio::VertRes::Config::Recipes::Common';
with 'Bio::VertRes::Config::Recipes::Roles::RegisterStudy';
with 'Bio::VertRes::Config::Recipes::Roles::Reference';
with 'Bio::VertRes::Config::Recipes::Roles::CreateGlobal';
with 'Bio::VertRes::Config::Recipes::Roles::BacteriaRnaSeqExpression';

has 'protocol'  => ( is => 'ro', isa => 'Str',  default => 'StrandSpecificProtocol' );

override '_pipeline_configs' => sub {
    my ($self) = @_;
    my @pipeline_configs;
    
    $self->add_qc_config(\@pipeline_configs);
    
    push(
        @pipeline_configs,
        Bio::VertRes::Config::Pipelines::StampyMapping->new(
            database                       => $self->database,
            config_base                    => $self->config_base,
            overwrite_existing_config_file => $self->overwrite_existing_config_file,
            limits                         => $self->limits,
            reference                      => $self->reference,
            reference_lookup_file          => $self->reference_lookup_file
        )
    );
    
    $self->add_bacteria_rna_seq_expression_config(\@pipeline_configs);
    
    return \@pipeline_configs;
};

__PACKAGE__->meta->make_immutable;
no Moose;
1;


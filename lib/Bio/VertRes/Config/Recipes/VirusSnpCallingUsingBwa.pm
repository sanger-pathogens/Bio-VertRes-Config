package Bio::VertRes::Config::Recipes::VirusSnpCallingUsingBwa;
# ABSTRACT: Standard snp calling pipeline for virus

=head1 SYNOPSIS

Standard snp calling pipeline for virus. Register study, QC, map with bwa, snp call
   use Bio::VertRes::Config::Recipes::VirusSnpCallingUsingBwa;
   
   my $obj = Bio::VertRes::Config::Recipes::VirusSnpCallingUsingBwa->new( 
     database => 'abc', 
     limits => {project => ['Study ABC']}, 
     reference => 'ABC', 
     reference_lookup_file => '/path/to/refs.index'
     );
   $obj->create;
   
=cut

use Moose;
use Bio::VertRes::Config::Pipelines::QC;
use Bio::VertRes::Config::Pipelines::BwaMapping;
use Bio::VertRes::Config::Pipelines::SnpCalling;
use Bio::VertRes::Config::RegisterStudy;
extends 'Bio::VertRes::Config::Recipes::Common';
with 'Bio::VertRes::Config::Recipes::Roles::RegisterStudy';
with 'Bio::VertRes::Config::Recipes::Roles::Reference';
with 'Bio::VertRes::Config::Recipes::Roles::CreateGlobal';
with 'Bio::VertRes::Config::Recipes::Roles::VirusSnpCalling';

override '_pipeline_configs' => sub {
    my ($self) = @_;
    my @pipeline_configs;
    
    $self->add_qc_config(\@pipeline_configs);
    
    push(
        @pipeline_configs,
        Bio::VertRes::Config::Pipelines::BwaMapping->new(
            database                       => $self->database,
            database_connect_file          => $self->database_connect_file,
            config_base                    => $self->config_base,
            root_base                      => $self->root_base,
            log_base                       => $self->log_base,
            overwrite_existing_config_file => $self->overwrite_existing_config_file,
            limits                         => $self->limits,
            reference                      => $self->reference,
            reference_lookup_file          => $self->reference_lookup_file,
        )
    );
    
    # Insert BAM Improvment here
    
    $self->add_virus_snp_calling_config(\@pipeline_configs);
    
    return \@pipeline_configs;
};

__PACKAGE__->meta->make_immutable;
no Moose;
1;


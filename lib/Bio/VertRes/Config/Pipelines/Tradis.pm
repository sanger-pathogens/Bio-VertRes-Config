package Bio::VertRes::Config::Pipelines::Tradis;

# ABSTRACT: Create TraDIS config files

=head1 SYNOPSIS

Create TraDIS config files
   use Bio::VertRes::Config::Pipelines::Tradis;

   my $pipeline = Bio::VertRes::Config::Pipelines::Tradis->new(
     database => 'abc',
     reference => 'Staphylococcus_aureus_subsp_aureus_ABC_v1',
     limits => {
       project => ['ABC study'],
       species => ['EFG']
     }

     );
   $pipeline->to_hash();

=cut

use Moose;
use Bio::VertRes::Config::Pipelines::Common;
use Bio::VertRes::Config::References;
use Bio::VertRes::Config::Pipelines::Roles::MetaDataFilter;
use Bio::VertRes::Config::Pipelines::Roles::MultiplePrefix;
extends 'Bio::VertRes::Config::Pipelines::RnaSeqExpression';
with 'Bio::VertRes::Config::Pipelines::Roles::MetaDataFilter';
with 'Bio::VertRes::Config::Pipelines::Roles::MultiplePrefix';
with 'Bio::VertRes::Config::Pipelines::Roles::FilenameWithReference';

has 'protocol'           => ( is => 'ro', isa => 'Str',  default => 'TradisProtocol' );
has '_mapping_quality'    => ( is => 'ro', isa => 'Int',  default => 10 );

__PACKAGE__->meta->make_immutable;
no Moose;
1;


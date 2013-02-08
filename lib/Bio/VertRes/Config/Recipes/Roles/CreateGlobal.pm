package Bio::VertRes::Config::Recipes::Roles::CreateGlobal;

# ABSTRACT: Moose Role for creating all the global config files after creation

=head1 SYNOPSIS

Moose Role for creating all the global config files after creation. Dont use in Bio::VertRes::Config::Recipes::Global

   with 'Bio::VertRes::Config::Recipes::Roles::CreateGlobal';

=method create

Hooks into the create method after the base method is run to create all the global config files

=cut

use Moose::Role;
use Bio::VertRes::Config::Recipes::Global;

after 'create' => sub {
    my ($self) = @_;

    Bio::VertRes::Config::Recipes::Global->new(
        database                       => $self->database,
        config_base                    => $self->config_base,
        overwrite_existing_config_file => $self->overwrite_existing_config_file
    )->create;

};

no Moose;
1;


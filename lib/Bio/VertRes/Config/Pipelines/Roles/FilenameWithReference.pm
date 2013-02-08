package Bio::VertRes::Config::Pipelines::Roles::FilenameWithReference;
# ABSTRACT: Moose Role to set the logfile name and config filename to include the reference

=head1 SYNOPSIS

Moose Role to set the logfile name and config filename to include the reference

   with 'Bio::VertRes::Config::Pipelines::Roles::FilenameWithReference';

=method log_file_name

Override the default logfile name method to include the reference in the name

=cut



use Moose::Role;


sub _construct_filename
{
  my ($self, $suffix) = @_;
  my $output_filename = $self->_limits_values_part_of_filename();
  
  $output_filename = join( '_', ($output_filename, $self->reference ) );

  return $self->_filter_characters_truncate_and_add_suffix($output_filename,$suffix);
}

override 'log_file_name' => sub {
    my ($self) = @_;
    return $self->_construct_filename('log');
};

override 'config_file_name' => sub {
    my ($self) = @_;
    return $self->_construct_filename('conf');
};


no Moose;
1;


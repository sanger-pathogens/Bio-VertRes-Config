package Bio::VertRes::Config::DatabaseManager;

# ABSTRACT: Handles database connection details, building the database handle and interaction with databases

use Moose;
use Bio::VertRes::Config::Exceptions;
use File::Slurper qw[read_text];
use DBI;

has 'database_connect_file' => ( is => 'rw', isa => 'Maybe[Str]' );
has 'host' => ( is => 'rw', isa => 'Str',     default => 'host' );
has 'port' => ( is => 'rw', isa => 'Str',     default => 'port' );
has 'database' => ( is => 'rw', isa => 'Str', required => 1 );
has 'user' => ( is => 'rw', isa => 'Str',     default=>'user' );
has 'password' => ( is => 'rw', isa => 'Str', default => 'password' );

sub BUILD { 
  my ($self) = @_; 
  $self->database_connect_file($ENV{VERTRES_DB_CONFIG}) unless defined $self->database_connect_file;
  Bio::VertRes::Config::Exceptions::FileDoesntExist->throw(error => 'Couldnt find database connect file ')
    unless (defined $self->database_connect_file);
  Bio::VertRes::Config::Exceptions::FileDoesntExist->throw(error => 'Couldnt find database connect file '.$self->database_connect_file)
    unless (-f $self->database_connect_file);
}

sub build_database_connection_details {
    my ($self) = @_;  
    my $connection_details;
    if ( -f $self->database_connect_file ) {
        my $text = read_text( $self->database_connect_file );
        $connection_details = eval($text);
    } else {
      Bio::VertRes::Config::Exceptions::FileDoesntExist->throw(error => 'Couldnt open database connection details '.$self->database_connect_file);
    }
    return $connection_details;
}

sub build_database_handle {
  my ($self) = @_;

  my %connection_details = %{ $self->build_database_connection_details };
  my $host = $connection_details{ $self->host };
  my $port = $connection_details{ $self->port };
  my $user = $connection_details{ $self->user };
  my $password = $connection_details{ $self->password };

  my $connection_str = join(':',('DBI', 'mysql', 'host='.$host, 'port='.$port.';database='.$self->database ));
  my $dbh = DBI->connect($connection_str, $user, $password, {'RaiseError' => 1, 'PrintError' => 1});
  return $dbh;
}

sub get_study_name_from_ssid {
  my ($self, $ssid) = @_;
  my $dbh = $self->build_database_handle;
  my $sth = $dbh->prepare("select name from study where id_study_lims = ?");
  $sth->execute($ssid);
  my @study_names = $sth->fetchrow_array;
  return @study_names;
}

sub get_data_access_groups {
  my ($self, $study_name) = @_;
  my @data_access_groups;
  eval { my $dbh = $self->build_database_handle; };
  if ( !$@ ) {
    my $dbh = $self->build_database_handle;
    my $sth = $dbh->prepare("select data_access_group from study where name = ?");
    $sth->execute($study_name);
    my $dag_string = $sth->fetchrow_array;
    @data_access_groups = split(' ', $dag_string) if defined $dag_string && $dag_string ne '';
  }

  return @data_access_groups;
}

__PACKAGE__->meta->make_immutable;
no Moose;
1;

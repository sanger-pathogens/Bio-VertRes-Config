package Bio::VertRes::Config::Exceptions;
# ABSTRACT: Exceptions for input data 

=head1 SYNOPSIS

Exceptions for input data 

=cut


use Exception::Class (
    Bio::VertRes::Config::Exceptions::FileDoesntExist   => { description => 'Couldnt open the file' },
    Bio::VertRes::Config::Exceptions::FileCantBeModified => { description => 'Couldnt open the file for modification' },
    Bio::VertRes::Config::Exceptions::InvalidType => { description => 'Invalid type passed in, can only be one of study/file/lane/library/sample' },
);  

1;

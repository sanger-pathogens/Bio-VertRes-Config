package Bio::VertRes::Config::Utils;

=head1 SYNOPSIS

Just somewhere to keep minor functions (which don't warrant instantiating an object)
that we want to be available throughout Bio::VertRes::Config

=cut

require Exporter;
@ISA = qw(Exporter);
@EXPORT_OK = qw(sort_hash_keys);

=head2 sort_hash_keys

Use this with C<sort> for a standardized sorting of hash keys.

=cut

sub sort_hash_keys {
   my($a,$b) = @_;
   return($a cmp $b);
}

1;

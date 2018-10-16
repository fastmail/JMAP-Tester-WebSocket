use v5.10.0;
use warnings;

package JMAP::Tester::WebSocket::Role::Result;
# ABSTRACT: the kind of thing that you get back for a request

use Moo::Role;

use JMAP::Tester::Abort ();

use namespace::clean;

=head1 OVERVIEW

This is the role consumed by the class of any object returned by JMAP::Tester's
C<request> method.  Its only guarantee, for now, is an C<is_success> method,
and an C<ws_response> method.

=cut

requires 'is_success';

has ws_response => (
  is => 'ro',
);

=method response_payload

Returns the raw payload of the response, if there is one. Empty string
otherwise. Mostly this will be C<< $self->ws_response >>
but other result types may exist that don't have a ws_response...

=cut

sub response_payload {
  my ($self) = @_;

  return $self->ws_response || '';
}

=method assert_successful

This method returns the result if it's a success and otherwise aborts.

=cut

sub assert_successful {
  my ($self) = @_;

  return $self if $self->is_success;

  my $str = $self->can('has_ident') && $self->has_ident
          ? $self->ident
          : "JMAP failure";

  die JMAP::Tester::Abort->new($str);
}

=method assert_successful_set

  $result->assert_successful_set($name);

This method is equivalent to:

  $result->assert_successful->sentence_named($name)->as_set->assert_no_errors;

C<$name> must be provided.

=cut

sub assert_successful_set {
  my ($self, $name) = @_;
  $self->assert_successful->sentence_named($name)->as_set->assert_no_errors;
}

=method assert_single_successful_set

  $result->assert_single_successful_set($name);

This method is equivalent to:

  $result->assert_successful->single_sentence($name)->as_set->assert_no_errors;

C<$name> may be omitted, in which case the sentence name is not checked.

=cut

sub assert_single_successful_set {
  my ($self, $name) = @_;
  $self->assert_successful->single_sentence($name)->as_set->assert_no_errors;
}

1;

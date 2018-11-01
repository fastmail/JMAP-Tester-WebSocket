use v5.10.0;
use warnings;

package JMAP::Tester::WebSocket::Role::WebSocketResult;
# ABSTRACT: the kind of thing that you get back for a WebSocket request

use Moo::Role;

with 'JMAP::Tester::Role::Result';

=head1 OVERVIEW

This is the role consumed by the class of any object returned by
L<JMAP::Tester::WebSocket>'s C<request> method.

=cut

has ws_response => (
  is => 'ro',
);

=method response_payload

Returns the raw payload of the response, if there is one. Empty string
otherwise.

=cut

sub response_payload {
  my ($self) = @_;

  return $self->ws_response || '';
}

1;

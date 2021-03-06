package WWW::Shorten::5gp;

use 5.008001;
use strict;
use warnings;

use Carp;
use JSON::PP;

use base qw( WWW::Shorten::generic Exporter );
our @EXPORT = qw( makeashorterlink makealongerlink );
our $VERSION = '1.02';

my $service = 'http://5.gp/api/';

sub makeashorterlink ($) {
    my $url = shift or croak 'No URL passed to makeashorterlink';
    my $ua = __PACKAGE__->ua();
    my $resp = $ua->get($service .'short?longurl=' . $url);

    if (!$resp->is_success) {
        carp $resp->status_line;
        return;
    }
    my $result = decode_json $resp->content;
    return $result->{url};
}

sub makealongerlink ($) {
    my $url = shift or croak 'No 5.gp key / URL passed to makealongerlink';
    my $ua = __PACKAGE__->ua();

    $url = "http://5.gp/$url" unless $url =~ m!^http://!i;

    my $resp = $ua->get($service . 'long?shorturl=' . $url);

    if (!$resp->is_success) {
        carp $resp->status_line;
        return;
    }
    my $result = decode_json $resp->content;
    return $result->{$url}->{target_url};
}

1;

__END__

=head1 NAME

WWW::Shorten::5gp - Perl interface to 5.gp - those are some short URLs!

=head1 SYNOPSIS

  use WWW::Shorten '5gp';

  $short_url = makeashorterlink($long_url);
  $long_url  = makealongerlink($short_url);

=head1 DESCRIPTION

A Perl interface to the web site 5.gp. 5gp simply maintains
a database of long URLs, each of which has a unique identifier.

5.gp has the benefit of being pretty reliable (so far) as well as
having a really tiny domain name. The domain name makes tinyurl.com
seem to be not so tiny at all!

=head1 Functions

=head2 makeashorterlink

The function C<makeashorterlink> will call the 5gp web site passing
it your long URL and will return the shorter 5gp version.

=head2 makealongerlink

The function C<makealongerlink> does the reverse. C<makealongerlink>
will accept as an argument either the full 5gp URL or just the
5gp identifier.

If anything goes wrong, then either function will return C<undef>.

=head2 EXPORT

makeashorterlink, makealongerlink

=head1 SUPPORT, THANKS and SUCH

See the main L<WWW::Shorten> docs.

=head1 LICENSE

This software is copyright (c) 2015 by Michiel Beijen.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 REPOSITORY

L<https://github.com/mbeijen/WWW-Shorten-5gp>

=head1 AUTHOR

Michiel Beijen <michiel.beijen@gmail.com>

I am not affiliated with 5.gp - I just like short domains!

=head1 SEE ALSO

L<WWW::Shorten>, L<perl>, L<http://5.gp/>

=cut


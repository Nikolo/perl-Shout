#!/usr/bin/perl -w
use strict;
use Test::More tests => 3;
use Test::Fake::HTTPD;
use Data::Dumper;

### Test 1: require
use_ok('Shout');
ok( 1 );

my $httpd = run_http_server {
    my $req = shift;
    if ($req->{headers}->{Authorization} ne 'Basic c291cmNlOnBhJCR3b3JkIQ==') {
        return HTTP::Response->new( 401, "asd" );
    }
    warn Dumper($req);
    return HTTP::Response->new( 200 );
};


### Test 2: constructor
my $streamer = Shout->new(
	host		=> "127.0.0.1",
	port		=> $httpd->port,
	mount		=> "testing",
	password	=> 'pa$$word!',
);
ok( defined $streamer );

warn $streamer->open;
warn $streamer->get_error;

### Test 3: connect/disconnect/error
if ($streamer->open eq Shout::SHOUTERR_SUCCESS()) {
	print "Connected...\n";
	$streamer->close;
	ok( 1 );
} else {
	print "Couldn't connect: "; print $streamer->get_error . "\n";
	ok( 0 );
}


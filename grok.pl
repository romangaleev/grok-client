#!/usr/bin/env perl
package UA;
use base 'LWP::UserAgent';

sub get_basic_credentials {
    return $ENV{USER}, $ENV{PASSWORD};
}

package main;
use strict;
use Web::Scraper;
use JSON;


my ($term) = @ARGV;
if(not defined $term or not defined $ENV{USER} or not defined $ENV{PASSWORD}) {
	print "Usage: HTTPS_CA_FILE=gooddata.pem USER=username PASSWORD=password $0 search_term\n";
	exit;
}

our $base = 'https://opengrok.intgdc.com/source/';
our $search = 'https://opengrok.intgdc.com/source/search';

my $ua = UA->new;
my $re = $ua->get( $base );

if ($re->status_line eq '401 Authorization Required') {
	print "Not Authorized: ", $ENV{USER}, "\n";
	exit;
}

my $p = scraper {
	process "#ptbl option", 'opt[]' => '@value';
};

my $repo = $p->scrape( $re->content );

my @projects = map { sprintf("project=%s", $_) } @{ $repo->{opt} };

my $q = sprintf("q=\"%s\"", $term);

my $query = join('&', $q, @projects);

my $result = $ua->get( join('?', $search, $query) );

my $r = scraper {
	process "#results tr", "tr[]" => scraper {
		process "td.f a", file => { 'name' => 'TEXT', 'link' => '@href' };
		process "a.s", "line[]" => 'TEXT';
	};
};

my $re = $r->scrape( $result->content );

foreach (@{$re->{tr}}) {
	if (my $f = $_->{file}) {
		my $link = $f->{link};
		my $name = quotemeta($f->{name});
		$link =~ s/^.*xref\///;
		$link =~ s/$name$//;
		print $link, "\n";
		print "  ", $f->{name}, "\n";
		foreach my $line (@{$_->{line}}) {
			print "    $line\n";
		}
		print "\n";
	}
}

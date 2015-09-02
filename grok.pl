#!/usr/bin/env perl
use strict;
use Web::Scraper;
use JSON;
use UA;

BEGIN {
	$ENV{HTTPS_CA_FILE} ||= "gooddata.pem";
};

sub LOG(@) { print join(" ", @_), "\n" }

my ($term) = @ARGV;
if(not defined $term) {
	print "Usage: $0 search_term\n";
	print " or  : HTTPS_CA_FILE=gooddata.pem $0 search_term\n";
	print " or  : HTTPS_CA_FILE=gooddata.pem USER=username PASSWORD=password $0 search_term\n";
	exit;
}

our $base = 'https://opengrok.intgdc.com/source/';
our $search = 'https://opengrok.intgdc.com/source/search';

my $ua = UA->new;
my $re = $ua->get( $base );

if ($re->code != 200) {
	print $re->header('WWW-Authenticate');
	LOG "Initial page failure:", $ENV{USER}, "code:", $re->code, $re->status_line;
	exit;
}

my $p = scraper {
	process "#ptbl option", 'opt[]' => '@value';
};

my $repo = $p->scrape( $re->content );

my @projects = map { sprintf("project=%s", $_) } @{ $repo->{opt} };

LOG "Number of projects:", scalar(@projects);

my $q = sprintf("q=\"%s\"", $term);

my $query = join('&', "n=1024", $q, @projects);

my $result = $ua->get( join('?', $search, $query) );

if ($result->code != 200) {
	LOG "Search request failure: ", $result->code, $result->status_line;
}

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

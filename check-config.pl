#!/usr/bin/env perl
use strict;

sub check_module($$) {
	my ($module, $error) = @_;
	eval "require $module";
	if ($@) {
		print $error;
	}
}

check_module
	'LWP::Authen::Negotiate', "No LWP::Authen::Negotiate module installed. Kerberos tickets are unavailable\n";
check_module
	'Web::Scraper', "No Web::Scraper module installed. Please install it: cpanm Web::Scraper\n";

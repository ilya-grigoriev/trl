#!/usr/bin/env perl
use strict;
use warnings;

use lib "./";
use Request;
use Args;

Args::check_args();

my @cookies = Request::get_cookies();

my $request = Request::request_get_translating(Args::format_text($Args::text_request), @cookies);
if ($request =~ /"type": "captcha"/) {
	print "too many requests\n";
	exit(1);
}
elsif ($request =~ m/Connection timed out/) {
	print "problem with connection\n";
	exit(1);
}

if ($request =~ /"text":\["((?:(?!(")).)*)"\]/) {
    print "\n";
	print "$Args::text_request -> $1\n";
    print "\n";

    if ($Args::is_examples == 1) {
        my @examples = Request::get_examples($Args::text_request);
        foreach (@examples) {
            $_ =~ s/\n//;
            my ($dst, $src) = split(/\|\|/, $_);

            if ($Args::no_colors == 0) {
                my $random_color_n = int(rand(255));
                my $random_color = "\033[38;5;$random_color_n"."m";
                print $random_color.$dst."\e[0m\n";
            }
            else {
                print $dst."\e[0m\n";
            }

            print "\e[3m".$src."\e[0m\n";
            print "\n";
        }
    }
}
else {
	print "$request\n";
}

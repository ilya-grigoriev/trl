use strict;
use warnings;

use lib "./";
use Request;
use Args;
use Print;
use Text;

Args::check_args();

my @cookies = Request::get_cookies();

sub translate {
	my $text;

	if ($Args::in_live == 1) {
		$text = Text::format_text(Text::get_input(), "output");
	}
	else {
		$text = $Args::text_request;
	}

	my $request = Request::request_get_translating(Text::format_text($text, "request"), @cookies);
	if ($request =~ /"type": "captcha"/) {
		if ($Args::in_live == 0) {
			print "too many requests\n";
			exit(1);
		}

		print "\ntoo many requests\n\n";
	}
	elsif ($request =~ m/Connection timed out/) {
		if ($Args::in_live == 1) {
			print "\n";
		}
		print "problem with connection\n";
		exit(1);
	}
	elsif ($request =~ /"text":\["((?:(?!(")).)*)"\]/) {
		if ($Args::in_live == 0) {
			print "$Args::text_request -> $1\n";
		}
		else {
			print " -> $1\n\n";
		}

		if ($Args::is_examples == 1) {
			Print::print_examples($text);
		}

		if ($Args::is_synonyms == 1) {
			Print::print_synonyms($text);
		}

		if ($Args::is_antonyms == 1) {
			Print::print_antonyms($text);
		}
	}
	else {
		print "request: $request\n";
	}
};

if ($Args::in_live == 0) {
	translate();
}
else {
	while () {
		translate();
	}
}

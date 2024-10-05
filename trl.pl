use strict;
use warnings;

use lib "./";
use Request;
use Args;
use Print;

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
	print "$Args::text_request -> $1\n";

    if ($Args::is_examples == 1) {
		Print::print_examples();
    }
}
else {
	print "request: $request\n";
}

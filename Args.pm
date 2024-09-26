package Args;

our $text_request;
my $is_examples = 0;
sub check_args {
	foreach (@ARGV) {
		if ($_ eq "-e") {
			$is_examples = 1;
		}
		else {
			$text_request = $_;
		}
	}

	if ($text_request eq "") {
		print STDERR "no text input";
		exit(1);
	}
};

sub format_text {
	my $text = shift;
	$Args::text =~ s/\n//g;
	$Args::text =~ s/ /%20/g;
	return $text;
};

1;

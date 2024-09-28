package Args;

our $text_request;
our @langs = ("en", "ru");
our $is_examples = 0;
our $no_colors = 0;

sub check_args {
    my $ind = 0;
	foreach (@ARGV) {
        if ($_ eq "-pl" || $_ eq "--print-langs") {
            Request::print_supported_languages();
            exit(0);
        }
        elsif ($_ eq "-nc" || $_ eq "--no-colors") {
            $no_colors = 1;
        }
        elsif ($_ eq "--lang" || $_ eq "-l") {
            @langs = split(/-/, $ARGV[$ind + 1]);
            if (@langs[0] eq "" || @langs[1] eq "") {
                print STDERR "problem with setting languages\n";
                exit(1);
            }
        }
        elsif ($_ eq "--examples" || $_ eq "-e") {
            $is_examples = 1;
        }
		else {
			$text_request = $_;
		}

        $ind++;
	}

	if ($text_request eq "") {
		print STDERR "no text input\n";
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

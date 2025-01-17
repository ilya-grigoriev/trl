package Args;

our $text_request;
our @langs = ("en", "ru");
our $is_examples = 0;
our $no_colors = 0;
our $in_live = 0;

sub check_args {
    my $ind = 0;
	foreach (@ARGV) {
        if ($_ eq "-h" || $_ eq "--help") {
            print "trl [-e] [--examples] [-nc] [--no-colors] [-l] [--langs] [-pl] [--print-langs] text\n";
            exit(0);
        }
        elsif ($_ eq "-pl" || $_ eq "--print-langs") {
            Request::print_supported_languages();
            exit(0);
        }
        elsif ($_ eq "-nc" || $_ eq "--no-colors") {
            $no_colors = 1;
        }
		elsif ($_ eq "-il" || $_ eq "--in-live") {
			$in_live = 1;
		}
        elsif ($_ eq "--langs" || $_ eq "-l") {
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

	if ($text_request eq "" && $in_live == 0) {
		print STDERR "no text input\n";
		exit(1);
	}

	if ($in_live == 1) {
		print "start translating:\n";
	}
};


1;

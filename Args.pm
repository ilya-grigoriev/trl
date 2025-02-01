package Args;
use strict;
use warnings;

our $text_request = '';
our @langs = ("en", "ru");
our $is_examples = 0;
our $no_colors = 0;
our $in_live = 0;

use constant {
    EXIT_SUCCESS => 0,
    EXIT_FAILURE => 1,
};

sub check_args {
    if (!@ARGV) {
        print_usage();
        exit(EXIT_FAILURE);
    }
    
    my $ind = 0;
    while ($ind < @ARGV) {
        $_ = $ARGV[$ind];
        if ($_ eq "-h" || $_ eq "--help") {
            print_usage();
            exit(EXIT_SUCCESS);
		}
        elsif ($_ eq "-pl" || $_ eq "--print-langs") {
            Request::print_supported_languages();
            exit(EXIT_SUCCESS);
        }
        elsif ($_ eq "-nc" || $_ eq "--no-colors") {
            $no_colors = 1;
        }
		elsif ($_ eq "-il" || $_ eq "--in-live") {
			$in_live = 1;
		}
        elsif ($_ eq "--langs" || $_ eq "-l") {
            $ind++;
            parse_languages($ARGV[$ind]);
        }
        elsif ($_ eq "--examples" || $_ eq "-e") {
            $is_examples = 1;
        }
        else {
            $text_request = $_;
        }
        $ind++;
    }

    validate_input();
}

sub print_usage {
    print "Usage: trl [OPTIONS] text\n";
    print "Options:\n";
    print "  -e, --examples     show examples\n";
    print "  -nc, --no-colors   disable colored output\n";
    print "  -l, --langs        specify languages (format: lang1-lang2)\n";
    print "  -pl, --print-langs print supported languages\n";
    print "  -il, --in-live     enable live translation mode\n";
    print "  -h, --help         show this help message\n";
}

sub parse_languages {
    @langs = split(/-/, shift);
    unless (@langs == 2 && $langs[0] && $langs[1]) {
        die "Error: Invalid language format. Use: lang1-lang2\n";
    }
}

sub validate_input {
    if ($text_request eq "" && !$in_live) {
        die "Error: No text input provided\n";
    }

    if ($in_live) {
        print "Starting translation mode:\n";
    }
}

1;

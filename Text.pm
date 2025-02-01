package Text;
use utf8;
use Encode;

sub move_previous_line {
	print "\033[1F";
};

sub move_end_of_line {
	my $len_text = shift;
	$len_text -= 1;

	print "\033[".$len_text."C";
};

sub get_input {
	my $text = <STDIN>;
	move_previous_line();
	move_end_of_line(length(decode("UTF-8", $text)));
	return $text;
};

sub format_text {
	my $text = shift;
	my $for_what_formatting = shift;
	$text =~ s/\n//g;

	if ($for_what_formatting eq "request") {
		$text =~ s/ /%20/g;
	}
	elsif ($for_what_formatting eq "output") {
		$text =~ s/%20g/ /g;
	}
	return $text;
};

1;

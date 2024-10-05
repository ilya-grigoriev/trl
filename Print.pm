package Print;

sub print_examples {
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

1;

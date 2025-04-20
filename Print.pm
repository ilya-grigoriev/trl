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

sub print_synonyms {
	print "\n";
	print "Synonyms:\n";
	print Request::get_synonyms(Text::format_text(shift, "request"));
}

sub print_antonyms {
	print "\n";
	print "Antonyms:\n";
	print Request::get_antonyms(Text::format_text(shift, "request"));
}

1;

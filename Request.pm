package Request;

sub request_get_translating {
	my $text = shift;
    my @cookies = shift;
    my @langs = @Args::langs;
	my $uuid = `uuidgen -t | tr -d - | tr -d "\n"`;

	return `curl -s -m 4 'https://translate.yandex.net/api/v1/tr.json/translate?id=$uuid-0-0&srv=tr-text&source_lang=$langs[0]&target_lang=$langs[1]&reason=cut&format=text&strategy=0&disable_cache=false&ajax=1&yu=$cookies[0]&sprvk=$cookies[1]%3D' \\
	-H 'accept: */*' \\
	-H 'accept-language: en-US,en;q=1.9' \\
	-H 'content-type: application/x-www-form-urlencoded' \\
	-H 'origin: https://translate.yandex.ru' \\
	-H 'priority: u=2, i' \\
	-H 'referer: https://translate.yandex.ru/' \\
	-H 'sec-ch-ua: "Chromium";v="130", "Not=A?Brand";v="8"' \\
	-H 'sec-ch-ua-mobile: ?1' \\
	-H 'sec-ch-ua-platform: "Linux"' \\
	-H 'sec-fetch-dest: empty' \\
	-H 'sec-fetch-mode: cors' \\
	-H 'sec-fetch-site: cross-site' \\
	-H 'user-agent: Mozilla/6.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36' \\
	-H 'x-retpath-y: https://translate.yandex.ru' \\
	--data-raw 'text=$text&options=5'`;
};

sub request_complete_translating {
	my $text = shift;
	return `curl -m 4 'https://predictor.yandex.net/suggest.json/complete?q=$text&srv=tr-text&lang=en&limit=5' 2>&1`;
};

sub get_cookies {
	my $cookies = `curl -s -o /dev/null https://translate.yandex.ru/ -c -`;

	$cookies =~ /yandexuid\t((\d)*)/;
	my $cookie_yu = $2;

	$cookies =~ /spravka\t((?:(?!(=)).)*)/;
	my $cookie_sprvk = $2;

	return ($cookie_yu, $cookie_sprvk);
};

sub get_examples {
    my $text = shift;
    my @langs = @Args::langs;
    $text =~ s/\s/%20/;

    return `curl -s 'https://dictionary.yandex.net/dicservice.json/queryCorpus?srv=tr-text&src=$text&lang=$langs[0]-$langs[1]&flags=1063&options=226&chunks=1&maxlen=200&v=2' \\
    -H 'accept: application/json' \\
    -H 'accept-language: en-US,en;q=0.9' \\
    -H 'cache: no-cache' \\
    -H 'origin: https://translate.yandex.ru' \\
    -H 'priority: u=1, i' \\
    -H 'sec-ch-ua: "Not;A=Brand";v="24", "Chromium";v="128"' \\
    -H 'sec-ch-ua-mobile: ?0' \\
    -H 'sec-ch-ua-platform: "Linux"' \\
    -H 'sec-fetch-dest: empty' \\
    -H 'sec-fetch-mode: cors' \\
    -H 'sec-fetch-site: cross-site' \\
    -H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/128.0.0.0 Safari/537.36' | jq -r '.result.examples[] | [.dst, .src] | join("||")'`;
}

sub print_supported_languages {
    my @langs = `curl -s https://www.loc.gov/standards/iso639-2/php/code_list.php | tr -d '\t\n\015' | grep -oP '<tr valign="top">(.*)<\/tr>'`;
    foreach (@langs) {
        my @matches = ($_ =~ /<td>([\w]{2})<\/td><td>([\w\s;,]*)<\/td>/g);

        my $ind = 0;
        while ($ind < scalar @matches) {
            print "$matches[$ind] -- $matches[$ind + 1]\n";
            $ind += 2;
        }
    }
};

2;

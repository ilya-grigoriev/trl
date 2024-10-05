package Request;

sub request_get_translating {
	my $text = shift;
    my @cookies = @_;
    my @langs = @Args::langs;
	my $uuid = `uuidgen -t | tr -d - | tr -d "\n"`;

	return `curl -s 'https://translate.yandex.net/api/v1/tr.json/translate?id=$uuid-3-0&srv=tr-text&source_lang=$langs[0]&target_lang=$langs[1]&reason=auto&format=text&strategy=0&disable_cache=false&ajax=1&yu=$cookies[0]' \\
	-X POST \\
   	-H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:131.0) Gecko/20100101 Firefox/131.0' \\
   	-H 'Accept: */*' \\
   	-H 'Accept-Language: en-US,en;q=0.5' \\
   	-H 'Accept-Encoding: gzip, deflate, br, zstd' \\
   	-H 'Content-Type: application/x-www-form-urlencoded' \\
   	-H 'X-Retpath-Y: https://translate.yandex.ru' \\
   	-H 'Origin: https://translate.yandex.ru' \\
   	-H 'Connection: keep-alive' \\
   	-H 'Referer: https://translate.yandex.ru/' \\
   	-H 'Sec-Fetch-Dest: empty' \\
   	-H 'Sec-Fetch-Mode: cors' \\
   	-H 'Sec-Fetch-Site: cross-site' \\
   	-H 'TE: trailers' \\
	--data-raw 'text=$text&options=4'`;
};

sub request_complete_translating {
	my $text = shift;
	return `curl -m 4 'https://predictor.yandex.net/suggest.json/complete?q=$text&srv=tr-text&lang=en&limit=5' 2>&1`;
};

sub get_cookies {
	my $cookies = `curl -s -o /dev/null https://translate.yandex.ru/ -c -`;

	$cookies =~ /yandexuid\t(\d*)/;
	my $cookie_yu = $1;

	return $cookie_yu;
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

1;

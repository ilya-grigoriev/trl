package Request;

sub request_get_translating {
	my $text = shift;
	my $cookie_yu = shift;
	my $cookie_sprvk = shift;
	my $uuid = `uuidgen -t | tr -d - | tr -d "\n"`;

	return `curl -s -m 3 'https://translate.yandex.net/api/v1/tr.json/translate?id=$uuid-0-0&srv=tr-text&source_lang=en&target_lang=ru&reason=cut&format=text&strategy=0&disable_cache=false&ajax=1&yu=$cookie_yu&sprvk=$cookie_sprvk%3D' \\
	-H 'accept: */*' \\
	-H 'accept-language: en-US,en;q=0.9' \\
	-H 'content-type: application/x-www-form-urlencoded' \\
	-H 'origin: https://translate.yandex.ru' \\
	-H 'priority: u=1, i' \\
	-H 'referer: https://translate.yandex.ru/' \\
	-H 'sec-ch-ua: "Chromium";v="129", "Not=A?Brand";v="8"' \\
	-H 'sec-ch-ua-mobile: ?0' \\
	-H 'sec-ch-ua-platform: "Linux"' \\
	-H 'sec-fetch-dest: empty' \\
	-H 'sec-fetch-mode: cors' \\
	-H 'sec-fetch-site: cross-site' \\
	-H 'user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36' \\
	-H 'x-retpath-y: https://translate.yandex.ru' \\
	--data-raw 'text=$text&options=4'`;
};

sub request_complete_translating {
	my $text = shift;
	return `curl -m 3 'https://predictor.yandex.net/suggest.json/complete?q=$text&srv=tr-text&lang=en&limit=5' 2>&1`;
};

sub get_cookies {
	my $cookies = `curl -s -o /dev/null https://translate.yandex.ru/ -c -`;

	$cookies =~ /yandexuid\t((\d)*)/;
	my $cookie_yu = $1;

	$cookies =~ /spravka\t((?:(?!(=)).)*)/;
	my $cookie_sprvk = $1;

	return ($cookie_yu, $cookie_sprvk);
}

1;

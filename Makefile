VERSION = 1.0

PREFIX = /usr/local
MANPREFIX = $(PREFIX)/share/man

all:
	pp -o trl trl.pl

install:
	mkdir -p $(PREFIX)/bin
	cp -f trl $(PREFIX)/bin
	chmod 755 $(PREFIX)/bin/trl

	mkdir -p $(MANPREFIX)/man1
	sed "s/VERSION/$(VERSION)/g" < trl.1 > $(MANPREFIX)/man1/trl.1
	chmod 644 $(MANPREFIX)/man1/trl.1

uninstall:
	rm -f $(DESTDIR)$(PREFIX)/bin/trl
	rm -f $(DESTDIR)$(MANPREFIX)/man1/trl.1

.PHONY: all uninstall

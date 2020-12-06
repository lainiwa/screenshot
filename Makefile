
PREFIX ?= /usr
MANDIR ?= $(PREFIX)/share/man
DOCDIR ?= $(PREFIX)/share/doc/screenshot

all:
	@echo Run \'make install\' to install screenshot

install:
	@install screenshot   -Dt $(DESTDIR)$(PREFIX)/bin/  -m755
	@install screenshot.7 -Dt $(DESTDIR)$(PREFIX)/man7/
	@install README.md    -Dt $(DESTDIR)$(DOCDIR)/

uninstall:
	@rm -f  $(DESTDIR)$(PREFIX)/bin/screenshot
	@rm -f  $(DESTDIR)$(MANDIR)/man7/screenshot.7
	@rm -fr $(DESTDIR)$(DOCDIR)

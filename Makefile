#

PACKAGE = reflector
prefix = /usr/local
vardir = /var/local
bindir = $(prefix)/bin
logdir = /var/local/log
pkgvardir = $(vardir)/$(PACKAGE)
sysconfdir = $(prefix)/etc
pkgsysconfdir = $(sysconfdir)/$(PACKAGE)

.PHONY: all install

all: reflector

%: %.in conf.sed
	sed -f conf.sed <$< >$@.tmp
	mv -f $@.tmp $@

conf.sed: Makefile
	(	echo "s,@PACKAGE@,$(PACKAGE),g;"; \
		echo "s,@pkgsysconfdir@,$(pkgsysconfdir),g;"; \
		echo "s,@logdir@,$(logdir),g;"; \
		echo "s,@pkgvardir@,$(pkgvardir),g;"; \
	) >$@.tmp
	mv -f $@.tmp $@

install: all
	test -d "$(pkgsysconfdir)" || mkdir -p "$(pkgsysconfdir)"
	test -d "$(bindir)" || mkdir -p "$(bindir)"
	install -m755 reflector "$(bindir)"

#

PACKAGE = reflector
prefix = /usr/local
vardir = /var/local
bindir = $(prefix)/bin
logdir = /var/local/log
pkglogdir = $(logdir)/$(PACKAGE)
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
		echo "s,@sysconfdir@,$(sysconfdir),g;"; \
		echo "s,@pkgsysconfdir@,$(pkgsysconfdir),g;"; \
		echo "s,@pkglogdir@,$(pkglogdir),g;"; \
		echo "s,@pkgvardir@,$(pkgvardir),g;"; \
	) >$@.tmp
	mv -f $@.tmp $@

install: all
	test -d "$(pkgsysconfdir)" || mkdir -p "$(pkgsysconfdir)"
	test -d "$(pkglogdir)" || mkdir -p "$(pkglogdir)"
	test -d "$(bindir)" || mkdir -p "$(bindir)"
	install -m755 reflector "$(bindir)"

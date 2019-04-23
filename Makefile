ifneq ($(DESTDIR),)
	prefix:=$(DESTDIR)/usr
else
	ifeq ($(prefix),)
		prefix :=/usr/local
	endif
endif
ifeq ($(INSTALL),)
	INSTALL=install
endif
DIST :=$(shell lsb_release -c|tr -d '[:blank:]'|cut -d: -f2)
version:=
ifneq ($(version),)
	ver = -N $(version)
endif
all:
	@echo "Run \`make install\` to install."
deb:
	@echo "Building Debian Packages"
	@echo "->Generating Changelog from commit log"
	gbp dch -c -R -D $(DIST) $(ver)
	@echo "->Started Building packages"
	@gbp buildpackage --git-tag --git-retag --git-sign-tags
ifeq ($(DESTDIR),)
install:
	$(INSTALL) -m 755 -D apk-thumbnailer $(prefix)/bin/apk-thumbnailer
	$(INSTALL) -m 644 -D apk.thumbnailer $(prefix)/share/thumbnailers/apk.thumbnailer
	$(INSTALL) -m 644 -D apk-thumbnailer.1 $(prefix)/share/man/man1/apk-thumbnailer.1
	@gzip $(prefix)/share/man/man1/apk-thumbnailer.1
	mandb			
endif
install:
	$(INSTALL) -m 755 -D apk-thumbnailer $(prefix)/bin/apk-thumbnailer
	$(INSTALL) -m 644 -D apk.thumbnailer $(prefix)/share/thumbnailers/apk.thumbnailer
	$(INSTALL) -m 644 -D apk-thumbnailer.1 $(prefix)/share/man/man1/apk-thumbnailer.1
	@gzip $(prefix)/share/man/man1/apk-thumbnailer.1

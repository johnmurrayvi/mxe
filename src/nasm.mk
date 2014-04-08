# This file is part of MXE.
# See index.html for further information.

PKG             := nasm
$(PKG)_VERSION  := 2.11.02
$(PKG)_CHECKSUM := 3fe52cb53a964c1418c7a58b800b0dd507fabd88
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.nasm.us/pub/$(PKG)/releasebuilds/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
	$(WGET) -q -O- 'http://www.nasm.us/pub/nasm/releasebuilds/?C=M;O=D' | \
	$(SED) -n 's,.*<a href="\([0-9][^>]*\)\".*,\1,p' | \
	head -n1
endef

define $(PKG)_BUILD
    # native build of nasm - will the same for all targets
    # but we don't want to conflict with an un-prefixed version
    mkdir '$(1).native'
    cd '$(1).native' && '$(1)/configure' \
        --prefix='$(PREFIX)' \
        --program-prefix='$(TARGET)-'
    $(MAKE) -C '$(1).native' -j '$(JOBS)' install

    cd '$(1)' && '$(1)/configure' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef

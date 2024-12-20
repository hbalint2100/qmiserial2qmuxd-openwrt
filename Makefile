include $(TOPDIR)/rules.mk

PKG_NAME:=qmiserial2qmuxd
PKG_VERSION:=1.0.0
PKG_RELEASE=$(PKG_SOURCE_VERSION)

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)
PKG_MAINTAINER:=Balint Huszar <hbalint2100@yahoo.com>

include $(INCLUDE_DIR)/package.mk

define Package/$(PKG_NAME)
  SECTION:=qmiserial2qmuxd
  CATEGORY:=Utilities
  TITLE:=Utility program that accepts QMI over serial port and forwards it to QMUXD
  DEPENDS:=+libqmi +qmi-utils
endef

define Package/$(PKG_NAME)/description
	Utility program that accepts QMI over serial port and forwards it to QMUXD
endef

define Build/Prepare
	git submodule init
	git submodule update
	if git apply --check ./patches/Changed-termio.h-to-termios.h.patch; then \
		git apply ./patches/Changed-termio.h-to-termios.h.patch; \
	else \
		echo "Patch has already been applied or conflicts exist."; \
	fi
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./src/* $(PKG_BUILD_DIR)
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) CC=${TARGET_CROSS}gcc
endef

define Package/$(PKG_NAME)/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/qmiserial2qmuxd $(1)/usr/bin
endef 

$(eval $(call BuildPackage,$(PKG_NAME)))
include $(TOPDIR)/rules.mk

PKG_NAME:=auto-scripts
PKG_VERSION:=1.0
PKG_RELEASE:=1
PKGARCH:=all

include $(INCLUDE_DIR)/package.mk

define Package/auto-scripts
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Automatic First-Boot Scripts
endef

define Package/auto-scripts/description
  Embeds scripts into firmware:
  1. /etc/uci-defaults/99-first-run (runs once on first boot)
  2. /usr/bin/openwrt (manual settings menu, invoke via 'openwrt')
  3. /etc/networkdetection (network anomaly auto-restart, disabled by default)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/auto-scripts/install
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/99-first-run $(1)/etc/uci-defaults/99-first-run
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/openwrt $(1)/usr/bin/openwrt
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_BIN) ./files/networkdetection $(1)/etc/networkdetection
endef

$(eval $(call BuildPackage,auto-scripts))

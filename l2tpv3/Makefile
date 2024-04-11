include $(TOPDIR)/rules.mk

PKG_NAME:=l2tpv3
PKG_RELEASE:=1
PKG_LICENSE:=GPL-2.0

include $(INCLUDE_DIR)/package.mk

define Package/l2tpv3
  SECTION:=net
  CATEGORY:=Network
  MAINTAINER:=Harusame <admin@haru3.me>
  TITLE:=L2TPv3 in kernel mode support
  DEPENDS:= +kmod-l2tp +kmod-l2tp-eth +kmod-l2tp-ip +ip-full
  PKGARCH:=all
endef

define Package/l2tpv3/description
 L2TPv3 config support in /etc/config/network.
endef

define Build/Compile
endef

define Build/Configure
endef

define Package/l2tpv3/install
	$(INSTALL_DIR) $(1)/lib/netifd/proto
	$(INSTALL_BIN) ./files/l2tpv3.sh $(1)/lib/netifd/proto/l2tpv3.sh
endef

$(eval $(call BuildPackage,l2tpv3))

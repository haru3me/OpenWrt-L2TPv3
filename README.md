# L2TPv3 support module for OpenWrt

## Caution
This is made just for my VPN setup with WireGuard, there is no support for multi-session usage (good enough for me with 1 session). 

I've not tested on other environment. 

**Use at your own risk!**

## How to use
* LuCI

    by install ```luci-proto-l2tpv3```, you can add your L2TPv3 interface on ```Network -> Interface```

* ```/etc/config/network```

    you can configure L2TPv3 interface like below
    ```conf
    config interface 'l2tp1'
        option proto 'l2tpv3'
        option remote '10.0.0.1'
        option local '10.0.0.2'
        option tunnel_id '101'
        option peer_tunnel_id '100'
        option encap 'udp'
        option udp_sport '5000'
        option udp_dport '5001'
        option udp_csum '0'
        option session_id '11'
        option peer_session_id '10'
        option mtu '1500'
        option defaultroute '0'
    ```

## How to build

0. Note

    Since it is architecture-independent source, my package built with ```i386_pentium4``` shoud work on various devices. so I'll share prebuilt packages on Release.

1. Obtain sources

    ```sh
    git clone https://github.com/openwrt/openwrt.git -b openwrt-23.05
    git clone https://github.com/openwrt/luci.git
    ```

2. Place files from the repository
    
    * ```l2tpv3``` to ```openwrt/package/network/config/```
    * ```luci-proto-l2tpv3``` to ```luci/protocols/```

3. Prepare

    * Install requred software
        https://openwrt.org/docs/guide-developer/toolchain/install-buildsystem

    * Setup packages
        ```sh
        cd openwrt
        echo 'src-link luci /path/to/luci' > feeds.conf
        scripts/feeds update -a
        scripts/feeds install -a -p luci
        ```

4. Configure

    ```sh
    make menuconfig
    ```
    
    * Select your hardware
    * Mark M to ```l2tpv3``` on ```Network```
    * Mark M to ```luci-proto-l2tpv3``` on ```LuCI -> Protocols```

5. Build

    ```sh
    make -j4 tools/install
    make -j4 toolchain/install
    make -j4 target/linux/compile
    make package/l2tpv3/{clean,compile} V=s
    make package/luci-proto-l2tpv3/{clean,compile} V=s
    ```
6. Finish

    * ```l2tpv3_1_all.ipk``` on ```openwrt/bin/packages/<arch>/base/```
    * ```luci-proto-l2tpv3_0_all.ipk``` on ```openwrt/bin/packages/<arch>>/luci/```
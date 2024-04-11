'use strict';
'require form';
'require network';
'require tools.widgets as widgets';

network.registerPatternVirtual(/^l2tpv3-.+$/);

return network.registerProtocol('l2tpv3', {
	getI18n: function() {
		return _('L2TPv3 (Kernel Mode)');
	},

	getIfname: function() {
		return this._ubus('l3_device') || 'l2tpv3-%s'.format(this.sid);
	},

	getOpkgPackage: function() {
		return 'l2tpv3';
	},

	isFloating: function() {
		return true;
	},

	isVirtual: function() {
		return true;
	},

	getDevices: function() {
		return null;
	},

	containsDevice: function(ifname) {
		return (network.getIfnameOf(ifname) == this.getIfname());
	},

	renderFormOptions: function(s) {
		var o;

		o = s.taboption('general', form.Value, 'remote', _('Remote Address'));
		o.datatype = 'ipaddr';

		o = s.taboption('general', form.Value, 'local', _('Local Address'));
		o.datatype = 'ipaddr';

		o = s.taboption('general', form.Value, 'tunnel_id', _('Tunnel ID'));
		o.datatype = 'uinteger';

		o = s.taboption('general', form.Value, 'peer_tunnel_id', _('Peer Tunnel ID'));
		o.datatype = 'uinteger';

		o = s.taboption('general', form.ListValue, 'encap', _('Encap'));
		o.value('udp');
		o.value('ip');
		
		o = s.taboption('general', form.Value, 'udp_sport', _('UDP Source Port'), _('Required if encap is UDP'));
		o.datatype = 'uinteger';

		o = s.taboption('general', form.Value, 'udp_dport', _('UDP Destination Port'), _('Required if encap is UDP'));
		o.datatype = 'uinteger';

		o = s.taboption('general', form.Flag, 'udp_csum', _('UDP Checksum'), _('Optional if encap is UDP'));
		o.default = 'off';

		o = s.taboption('general', form.Flag, 'udp6_csum_tx', _('UDP TX Checksum (IPv6)'), _('Optional if encap is UDP'));
		o.default = 'off';

		o = s.taboption('general', form.Flag, 'udp6_csum_rx', _('UDP RX Checksum (IPv6)'), _('Optional if encap is UDP'));
		o.default = 'off';

		o = s.taboption('general', form.Value, 'session_id', _('Session ID'));
		o.datatype = 'uinteger';

		o = s.taboption('general', form.Value, 'peer_session_id', _('Peer Session ID'));
		o.datatype = 'uinteger';

		o = s.taboption('advanced', form.Value, 'mtu', _('MTU'));
		o.placeholder = '1366';
		o.datatype = 'max(9200)';
	}
});

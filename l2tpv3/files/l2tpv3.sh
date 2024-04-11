#!/bin/sh

[ -n "$INCLUDE_ONLY" ] || {
	. /lib/functions.sh
	. /lib/functions/network.sh
	. ../netifd-proto.sh
	init_proto "$@"
}

proto_l2tpv3_init_config() {
	#tunnel
	proto_config_add_string "remote"
	proto_config_add_string "local"
	proto_config_add_int "tunnel_id"
	proto_config_add_int "peer_tunnel_id"
	proto_config_add_string "encap"
	proto_config_add_int "udp_sport"
	proto_config_add_int "udp_dport"
	proto_config_add_boolean "udp_csum"
	proto_config_add_boolean "udp6_csum_tx"
	proto_config_add_boolean "udp6_csum_rx"

	#session
	#proto_config_add_int "sess_tunnel_id" <- duplicate of tunnel one
	proto_config_add_int "session_id"
	proto_config_add_int "peer_session_id"

	#optional
	proto_config_add_int "mtu"

	available=1
	no_proto_task=1
}

proto_l2tpv3_setup() {
	local config="$1"

	config_load network
	if_name="l2tpv3-$1"

	config_get remote "${config}" "remote"
	config_get local "${config}" "local"
	config_get tunnel_id "${config}" "tunnel_id"
	config_get peer_tunnel_id "${config}" "peer_tunnel_id"
	config_get encap "${config}" "encap"
	config_get udp_sport "${config}" "udp_sport"
	config_get udp_dport "${config}" "udp_dport"
	config_get udp_csum "${config}" "udp_csum"
	config_get udp6_csum_tx "${config}" "udp6_csum_tx"
	config_get udp6_csum_rx "${config}" "udp6_csum_rx"
	
	config_get session_id "${config}" "session_id"
	config_get peer_session_id "${config}" "peer_session_id"

	config_get mtu "${config}" "mtu"

	ip l2tp del session tunnel_id "${tunnel_id}" session_id "${session_id}" 2>/dev/null
	ip l2tp del tunnel tunnel_id "${tunnel_id}" 2>/dev/null

	proto_init_update "${config}" 1

	if [ "${encap}" = "udp" ];then
		if [ "${udp_csum}" = 0 ]; then
			udp_csum="off"
		else
			udp_csum="on"
		fi

		if [ "${udp6_csum_tx}" = 0 ]; then
			udp6_csum_tx="off"
		else
			udp6_csum_tx="on"
		fi

		if [ "${udp6_csum_rx}" = 0 ]; then
			udp6_csum_rx="off"
		else
			udp6_csum_rx="on"
		fi

		ip l2tp add tunnel \
			remote "${remote}" \
			local "${local}" \
			tunnel_id "${tunnel_id}" \
			peer_tunnel_id "${peer_tunnel_id}" \
			encap "${encap}" \
			udp_sport "${udp_sport}" \
			udp_dport "${udp_dport}" \
			udp_csum "${udp_csum}" \
			udp6_csum_tx "${udp6_csum_tx}" \
			udp6_csum_rx "${udp6_csum_rx}"
	else
		ip l2tp add tunnel \
			remote "${remote}" \
			local "${local}" \
			tunnel_id "${tunnel_id}" \
			peer_tunnel_id "${peer_tunnel_id}" \
			encap "${encap}"
	fi

	if [ $? -ne 0 ]; then
		sleep 5
		proto_setup_failed "${config}"
		exit 1;
	fi

	ip l2tp add session \
		name "${if_name}" \
		tunnel_id "${tunnel_id}" \
		session_id "${session_id}" \
		peer_session_id "${peer_session_id}"

	if [ $? -ne 0 ]; then
		sleep 5
		proto_setup_failed "${config}"
		exit 1;
	fi

	ip link set dev "${if_name}" up

	if [ "${mtu}" ]; then
		ip link set mtu "${mtu}" dev "${if_name}"
	fi

}

proto_l2tpv3_teardown() {
	local config="$1"
	config_load network
	config_get tunnel_id "${config}" "tunnel_id"
	config_get session_id "${config}" "session_id"
	ip l2tp del session tunnel_id "${tunnel_id}" session_id "${session_id}" 2>/dev/null
	ip l2tp del tunnel tunnel_id "${tunnel_id}" 2>/dev/null
}

[ -n "$INCLUDE_ONLY" ] || {
	add_protocol l2tpv3
}

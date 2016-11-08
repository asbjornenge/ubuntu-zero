#!/bin/sh
init-zerotier || exit 1
export ZT_NC_NETWORK=/var/lib/zerotier-sdk/nc_$ZEROTIER_NETWORK_ID
export LD_PRELOAD=/libztintercept.so
nodejs /app.js

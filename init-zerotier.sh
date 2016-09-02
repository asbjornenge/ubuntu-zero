#!/bin/bash
export PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/

## Network Parameters
#
ZEROTIER_MEMBER_NAME=$(hostname)

if [ -z "$ZEROTIER_API_TOKEN" ]; then
    echo "Need to set \$ZEROTIER_API_TOKEN"
    exit 1
fi 

if [ -z "$ZEROTIER_NETWORK_ID" ]; then
    echo "Need to set \$ZEROTIER_NETWORK_ID"
    exit 1
fi 

## Init ZeroTier
#
echo '*** ZeroTier Node Ready: '"$ZEROTIER_MEMBER_NAME"
chown -R daemon /var/lib/zerotier-one
chgrp -R daemon /var/lib/zerotier-one
su daemon -s /bin/bash -c '/zerotier-sdk-service -d -U -p9993 >>/tmp/zerotier-sdk-service.out 2>&1'
virtip4=""
ZEROTIER_ADDRESS=""

# Wait for ZEROTIER_ADDRESS
while [ -z "$ZEROTIER_ADDRESS" ]; do
	sleep 0.2
	ZEROTIER_ADDRESS=$(zerotier-cli info | awk '{print $3}')
done

# Joing the ZEROTIER_NETWORK_ID
echo '*** ZeroTier Connect Network: '"$ZEROTIER_NETWORK_ID"
zerotier-cli join $ZEROTIER_NETWORK_ID > /dev/null
sleep 0.2

# Register with ZeroTier API
function zregister {
  curl -s -X POST --header "Content-Type: application/json" --header "Accept: application/json" --header 'Authorization: Bearer '$ZEROTIER_API_TOKEN https://my.zerotier.com/api/network/$1/member/$ZEROTIER_ADDRESS -d '{"name":"'$ZEROTIER_MEMBER_NAME'","config":{"authorized":true}}' > /dev/null
}
zregister $ZEROTIER_NETWORK_ID

# Wait for IP
while [ -z "$virtip4" ]; do
	sleep 0.2
	virtip4=`/zerotier-cli listnetworks | grep -F $ZEROTIER_NETWORK_ID | cut -d ' ' -f 9 | sed 's/,/\n/g' | grep -F '.' | cut -d / -f 1`
	dev=`/zerotier-cli listnetworks | grep -F "" | cut -d ' ' -f 8 | cut -d "_" -f 2 | sed "s/^<dev>//" | tr '\n' '\0'`
done
echo '*** ZeroTier Address: '$virtip4

# --- Test section ---
sleep 0.5
#export ZT_NC_NETWORK=/var/lib/zerotier-one/nc_"$dev"
#export LD_PRELOAD=/libztintercept.so

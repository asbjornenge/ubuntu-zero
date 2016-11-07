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
echo -n '*** ZeroTier Node: '"$ZEROTIER_MEMBER_NAME"

## Init ZeroTier SDK
#
export ZEROTIER_SDK_PATH=/var/lib/zerotier-sdk
mkdir -p $ZEROTIER_SDK_PATH/networks.d
cp /liblwip.so $ZEROTIER_SDK_PATH/liblwip.so
/zerotier-sdk-service -d -U -p9993 $ZEROTIER_SDK_PATH &
virtip4=""
ZEROTIER_ADDRESS=""
while [ -z "$ZEROTIER_ADDRESS" ]; do
	sleep 0.2
	ZEROTIER_ADDRESS=$(zerotier-cli -D$ZEROTIER_SDK_PATH info | awk '{print $3}')
done
echo " OK"

## Join Network
# 
echo -n '*** ZeroTier Connect Network: '"$ZEROTIER_NETWORK_ID"
zerotier-cli -D$ZEROTIER_SDK_PATH join $ZEROTIER_NETWORK_ID > /dev/null
sleep 0.2
# Register with ZeroTier API
function zregister {
  curl -s -X POST --header "Content-Type: application/json" --header "Accept: application/json" --header 'Authorization: Bearer '$ZEROTIER_API_TOKEN https://my.zerotier.com/api/network/$1/member/$ZEROTIER_ADDRESS -d '{"name":"'$ZEROTIER_MEMBER_NAME'","config":{"authorized":true}}' > /dev/null
}
zregister $ZEROTIER_NETWORK_ID
echo " OK"

## Wait for IP
#
echo -n '*** ZeroTier Address: '
while [ -z "$virtip4" ]; do
	sleep 0.2
	virtip4=`/zerotier-cli -D$ZEROTIER_SDK_PATH listnetworks | grep -F $ZEROTIER_NETWORK_ID | cut -d ' ' -f 9 | sed 's/,/\n/g' | grep -F '.' | cut -d / -f 1`
	dev=`/zerotier-cli -D$ZEROTIER_SDK_PATH listnetworks | grep -F "" | cut -d ' ' -f 8 | cut -d "_" -f 2 | sed "s/^<dev>//" | tr '\n' '\0'`
done
echo "$virtip4 OK"

# --- Test section ---
sleep 0.5
#export ZT_NC_NETWORK=/var/lib/zerotier-one/nc_"$dev"
#export LD_PRELOAD=/libztintercept.so

# UbuntuZero

UbuntuZero is a [Ubuntu](http://www.ubuntu.com/) base image for [Docker](https://www.docker.com/) with built in support for [ZeroTier](https://www.zerotier.com/) via the [ZeroTierSDK](https://github.com/zerotier/ZeroTierSDK). It is meant to be used as a base image. Take a look at [node-zero](https://github.com/asbjornenge/node-zero) or [app-node-zero](https://github.com/asbjornenge/app-node-zero) as examples.

This image provides a script called `init-zerotier`. If you want to enable `ZeroTier` for your container, you need a `init script` similar to this.

```sh
#!/bin/sh
init-zerotier || exit 1
export ZT_NC_NETWORK=/var/lib/zerotier-one/nc_$ZEROTIER_NETWORK_ID
export LD_PRELOAD=/libztintercept.so
redis-server // <- start your app
```

You also need to pass a `ZEROTIER_NETWORK_ID` and a `ZEROTIER_API_TOKEN` environment variables when starting the container. Take a look at the [app-node-zero](https://github.com/asbjornenge/app-node-zero) as an example.

enjoy.

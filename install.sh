#!/bin/sh
# https://github.com/robzr/bearDropper
# bearDropper install script - @robzr

BASE="https://raw.githubusercontent.com/Schimmelreiter/bearDropper/master/"

if [ -f /etc/init.d/bearDropper ] ; then
  echo Detected previous version of bearDropper - stopping
  /etc/init.d/bearDropper stop
fi
echo -e 'Retrieving and installing latest version'
uclient-fetch -qO /etc/init.d/bearDropper $BASE/src/init.d/bearDropper
uclient-fetch -qO /etc/config/bearDropper $BASE/src/config/bearDropper
uclient-fetch -qO /usr/sbin/bearDropper $BASE/bearDropper
chmod 755 /usr/sbin/bearDropper /etc/init.d/bearDropper

echo -e 'Processing historical log data (this can take a while)'
/usr/sbin/bearDropper -m entire -f stdout
echo -e 'Starting background process'
/etc/init.d/bearDropper enable
/etc/init.d/bearDropper start

dropbear_count=$(uci show dropbear | grep -c =dropbear)
dropbear_count=$((dropbear_count - 1))
for instance in $(seq 0 $dropbear_count); do
  dropbear_verbose=$(uci -q get dropbear.@dropbear[$instance].verbose || echo 0)
  if [ $dropbear_verbose -eq 0 ]; then
    uci set dropbear.@dropbear[$instance].verbose=1
    dropbear_conf_updated=1
  fi
done
if [ $dropbear_conf_updated ]; then
  uci commit
  echo "Verbose logging was configured for dropbear. Please restart the service to enable this change."
fi

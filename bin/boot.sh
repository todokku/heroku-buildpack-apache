#!/usr/bin/env bash
for var in `env|cut -f1 -d=`; do
  echo "PassEnv $var" >> /app/apache/etc/apache2/httpd.conf;
done

psmgr=/tmp/harvardkey-buildpack-wait
rm -f $psmgr
mkfifo $psmgr

# cat /app/apache/etc/apache2/httpd.conf

mkdir -p /app/apache/logs
mkdir -p /app/apache/var/cache
touch /app/apache/logs/error_log
touch /app/apache/logs/access_log

(
 COMMAND=${@:$n}
 echo "Launching ${COMMAND}..."
 echo 'app' > $psmgr
) &

echo "Launching apache..."
(
  echo "Launching apache..."
  /app/apache/sbin/httpd -DNO_DETACH
  echo 'apache' > $psmgr
) & 

read exit_process <$psmgr
echo "buildpack=apache at=exit process=$exit_process"
exit 1

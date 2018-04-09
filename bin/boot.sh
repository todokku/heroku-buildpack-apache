#!/usr/bin/env bash
for var in `env|cut -f1 -d=`; do
  echo "PassEnv $var" >> /app/apache/etc/apache2/httpd.conf;
done

# cat /app/apache/etc/apache2/httpd.conf

mkdir -p /app/apache/logs
mkdir -p /app/apache/var/cache
touch /app/apache/logs/error_log
touch /app/apache/logs/access_log
tail -F /app/apache/logs/error_log &
tail -F /app/apache/logs/access_log &

COMMAND=${@:$n}
echo "Launching ${COMMAND}..."
$COMMAND &
echo "Launching apache..."
exec /app/apache/sbin/httpd -DNO_DETACH

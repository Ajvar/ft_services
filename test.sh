#/bin/sh

if systemctl status nginx | grep 'active (running)' >/dev/null; then
    service nginx stop
fi
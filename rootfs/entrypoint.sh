#!/usr/bin/env sh
set -e

if [ -n "$ADMINER_DESIGN" ]; then
	# Only create link on initial start, to ensure that explicit changes to
	# adminer.css after the container was started once are preserved.
	if [ ! -e /tmp/.adminer-init ]; then
		ln -sf "designs/$ADMINER_DESIGN/adminer.css" /var/www/html/adminer.css
	fi
fi

mkdir -p /var/www/html/plugins-enabled || true

number=1
for PLUGIN in $ADMINER_PLUGINS; do
	php /var/www/html/plugin-loader.php "$PLUGIN" > /var/www/html/plugins-enabled/$(printf "%03d" $number)-$PLUGIN.php
	number=$(($number+1))
done

touch /tmp/.adminer-init || true

exec "$@"

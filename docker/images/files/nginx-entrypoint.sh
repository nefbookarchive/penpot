#!/usr/bin/env bash

#########################################
## App Frontend config
#########################################

update_flags() {
  if [ -n "$XENPOT_FLAGS" ]; then
    sed -i \
      -e "s|^//var xenpotFlags = .*;|var xenpotFlags = \"$XENPOT_FLAGS\";|g" \
      "$1"
  fi
}

update_flags /var/www/app/js/config.js


#########################################
## Nginx Config
#########################################

export XENPOT_BACKEND_URI=${XENPOT_BACKEND_URI:-http://xenpot-backend:6060};
export XENPOT_EXPORTER_URI=${XENPOT_EXPORTER_URI:-http://xenpot-exporter:6061};
XENPOT_DEFAULT_INTERNAL_RESOLVER="$(awk 'BEGIN{ORS=" "} $1=="nameserver" { sub(/%.*$/,"",$2); print ($2 ~ ":")? "["$2"]": $2}' /etc/resolv.conf)";
export XENPOT_INTERNAL_RESOLVER=${XENPOT_INTERNAL_RESOLVER:-$XENPOT_DEFAULT_INTERNAL_RESOLVER};
export XENPOT_HTTP_SERVER_MAX_MULTIPART_BODY_SIZE=${XENPOT_HTTP_SERVER_MAX_MULTIPART_BODY_SIZE:-367001600}; # Default to 350MiB

envsubst "\$XENPOT_BACKEND_URI,\$XENPOT_EXPORTER_URI,\$XENPOT_HTTP_SERVER_MAX_MULTIPART_BODY_SIZE" \
         < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf;

envsubst "\$XENPOT_INTERNAL_RESOLVER" \
         < /etc/nginx/overrides.d/resolvers.conf.template > /etc/nginx/overrides.d/resolvers.conf;

exec "$@";

#!/bin/sh
find . -iname "*.js" -exec sed -i -r  "s|site|${API_ROOT}|g" {} \;
find . -iname "*.js.map" -exec sed -i -r  "s|site|${API_ROOT}|g" {} \;
sed -ir "s|frontend|${API_ROOT}|g" /etc/nginx/conf.d/default.conf
sed -ir "s|backend|${BACKEND_URL}|g" /etc/nginx/conf.d/default.conf
nginx -g "daemon off;"

# Dockerfile for Front-End

# stage 1
FROM node:alpine3.15 AS build
WORKDIR /opt/frontend
RUN apk --verbose --update-cache --upgrade add \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/*
COPY --chown=0:0 . .
RUN sed -i "s|https://conduit.productionready.io|http://site|g" src/agent.js \
    && npm install && npm run build

# stage 2
FROM nginx:alpine AS prod
WORKDIR /usr/share/nginx/html
ENV BUILD_PATH=/opt/frontend/build
ENV API_ROOT=localhost
ENV BACKEND_URL=backend
COPY --chown=0:0 --from=build ${BUILD_PATH} ${WORKDIR}
COPY --chown=0:0  ./entrypoint.sh .
COPY --chown=0:0  ./default.conf /etc/nginx/conf.d
HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost/ || exit 1
EXPOSE 80
CMD [ "./entrypoint.sh" ]

### FDC-Client
FROM docker.io/library/node:24-alpine as build-client

ARG VITE_OIDC_AUTHORITY
ARG VITE_OIDC_CLIENT_ID
ARG VITE_OIDC_REDIRECT_URI
ARG VITE_BASE_PATH
ARG VITE_API_BASE_URL

ENV VITE_OIDC_AUTHORITY=$VITE_OIDC_AUTHORITY \
    VITE_OIDC_CLIENT_ID=$VITE_OIDC_CLIENT_ID \
    VITE_OIDC_REDIRECT_URI=$VITE_OIDC_REDIRECT_URI \
    VITE_BASE_PATH=$VITE_BASE_PATH \
    VITE_API_BASE_URL=$VITE_API_BASE_URL

WORKDIR /src
COPY FDC-Client .
RUN npm install && npm run build && npx vite build --base /

### FDC-Docs
FROM docker.io/library/alpine:3.22 as build-docs

RUN apk add --no-cache make py3-sphinx py3-sphinx_rtd_theme

WORKDIR /src
COPY FDC-Docs .
RUN make html

### FDC-Demo
FROM docker.io/library/debian:12

RUN apt-get update && apt-get upgrade -y && apt-get install -y apache2 && apt-get clean
RUN a2enmod proxy_http ssl && a2ensite default-ssl

COPY rails-proxy.conf /etc/apache2/conf-enabled/rails-proxy.conf

WORKDIR /var/www/html
COPY --from=build-client /src/dist .
COPY --from=build-docs /src/build/html ./docs

CMD ["apache2ctl", "-DFOREGROUND"]

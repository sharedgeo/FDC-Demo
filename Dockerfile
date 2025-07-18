### FDC-Client
FROM docker.io/library/node:24-alpine as build-client

WORKDIR /src
COPY FDC-Client .
ENV VITE_BASE_PATH="/map/"
RUN npm install && npm run build

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
COPY --from=build-client /src/dist /var/www/html/map
COPY --from=build-docs /src/build/html /var/www/html/docs

CMD ["apache2ctl", "-DFOREGROUND"]

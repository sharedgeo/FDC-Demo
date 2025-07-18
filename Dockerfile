### FDC-Client
FROM docker.io/library/node:24-alpine as build-client

WORKDIR /src
COPY FDC-Client .
RUN npm install && VITE_BASE_PATH='./' npm run build

### FDC-Docs
FROM docker.io/library/alpine:3.22 as build-docs

RUN apk add --no-cache make py3-sphinx py3-sphinx_rtd_theme

WORKDIR /src
COPY FDC-Docs .
RUN make html

### FDC-Demo
FROM docker.io/library/alpine:3.22

RUN mkdir -p /app/public
COPY --from=build-client /src/dist /app/public
COPY --from=build-docs /src/build/html /app/public/docs


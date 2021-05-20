FROM node:16 AS build
WORKDIR /build
ARG API_ENDPOINT=""
COPY webapp/public public
COPY webapp/src src
COPY webapp/package-lock.json .
COPY webapp/package.json .
COPY webapp/rollup.config.js .
COPY webapp/tsconfig.json .
ENV API_ENDPOINT=$API_ENDPOINT
RUN npm install
RUN npm run build

FROM zekro/seiteki:latest
WORKDIR /app
COPY --from=build /build/public .
ENV STK_ADDR="0.0.0.0:80" \
    STK_CACHEDURATION="720h" \
    STK_INDEXFILE="index.html" \
    STK_STATICDIR="/app" \
    STK_ROUTEMODE="static"

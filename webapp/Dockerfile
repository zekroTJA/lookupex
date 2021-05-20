FROM node:16-alpine
WORKDIR /build
COPY webapp/public .
COPY webapp/src .
COPY webapp/package-lock.json .
COPY webapp/package.json .
COPY webapp/rollup.config.js .
COPY webapp/tsconfig.json .
RUN apk add build-base python3
RUN npm install
RUN npm run build
EXPOSE 5000
ENV HOST=0.0.0.0
ENTRYPOINT ["npm", "start"]

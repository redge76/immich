FROM node:22.16.0-alpine3.20@sha256:2289fb1fba0f4633b08ec47b94a89c7e20b829fc5679f9b7b298eaa2f1ed8b7e
ENV COREPACK_ENABLE_AUTO_PIN=0
ENV COREPACK_ENABLE_DOWNLOAD_PROMPT=0
RUN corepack enable && corepack install -g pnpm && apk add --no-cache tini
RUN mkdir -p /pnpm/store && chown node:node -R /pnpm && mkdir -p /usr/local/etc && echo "store-dir=/pnpm/store" >> /usr/local/etc/npmrc
USER node
WORKDIR /usr/src/app
COPY --chown=node:node \
    ../open-api/typescript-sdk/package.json \
    ../open-api/typescript-sdk/pnpm-lock.yaml \
    ../open-api/typescript-sdk/
COPY --chown=node:node ./web/package.json ./web/pnpm-lock.yaml ./web/pnpm-workspace.yaml ./
COPY pnpm-workspace.yaml /usr/src
RUN pnpm install --frozen-lockfile
ENV CHOKIDAR_USEPOLLING=true
EXPOSE 24678
EXPOSE 3000
ENTRYPOINT ["/sbin/tini", "--", "/bin/sh"]

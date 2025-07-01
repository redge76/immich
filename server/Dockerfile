# dev build
FROM ghcr.io/immich-app/base-server-dev:202505131114@sha256:cf4507bbbf307e9b6d8ee9418993321f2b85867da8ce14d0a20ccaf9574cb995 AS dev

ENV PATH="${PATH}:/usr/src/app/bin" \
  IMMICH_ENV=development \
  NVIDIA_DRIVER_CAPABILITIES=all \
  NVIDIA_VISIBLE_DEVICES=all \
  npm_config_devdir=/buildcache/node_gyp

RUN apt-get install --no-install-recommends -yqq tini && \
  mkdir -p /buildcache/pnpm_store && \
  chown -R node:node /buildcache && \
  rm -rf /usr/src/app && \
  mkdir -p /usr/src/app && \
  chown node:node /usr/src/app

WORKDIR /usr/src/app

ENTRYPOINT ["tini", "--", "/bin/sh"]

FROM dev AS dev-container-server

RUN rm -rf /usr/src/app && \
  apt-get update && \
  apt-get install sudo inetutils-ping openjdk-11-jre-headless \
  vim nano -y --no-install-recommends --fix-missing && \
  rm -rf /var/lib/apt/lists/* && \
  usermod -aG sudo node && \
  echo "node ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER node

RUN sudo mkdir -p /workspaces/immich && \
  sudo chown node -R /workspaces && \
  sudo mkdir /immich-devcontainer && \
  sudo chown node -R /immich-devcontainer

COPY --chmod=777 \
  ../.devcontainer/server/*.sh \
  /immich-devcontainer/

COPY --chown=node:node .. /tmp/create-dep-cache/
WORKDIR /tmp/create-dep-cache
RUN make ci-all && rm -rf /tmp/create-dep-cache

WORKDIR /workspaces/immich

FROM dev-container-server AS dev-container-mobile
# Enable multiarch for arm64 if necessary
RUN if [ "$(dpkg --print-architecture)" = "arm64" ]; then \
  sudo dpkg --add-architecture amd64 && \
  sudo apt-get install -y --no-install-recommends \
  qemu-user-static \
  libc6:amd64 \
  libstdc++6:amd64 \
  libgcc1:amd64; \
  fi

# Flutter SDK
# https://flutter.dev/docs/development/tools/sdk/releases?tab=linux
ENV FLUTTER_CHANNEL="stable"
ENV FLUTTER_VERSION="3.29.3"
ENV FLUTTER_HOME=/flutter
ENV PATH=${PATH}:${FLUTTER_HOME}/bin

# Flutter SDK
RUN mkdir -p ${FLUTTER_HOME} && \
  curl -C - --output flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/${FLUTTER_CHANNEL}/linux/flutter_linux_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz \
  tar -xf flutter.tar.xz --strip-components=1 -C ${FLUTTER_HOME} && \
  rm flutter.tar.xz && \
  chown -R node ${FLUTTER_HOME}

RUN wget -qO- https://dcm.dev/pgp-key.public | sudo gpg --dearmor -o /usr/share/keyrings/dcm.gpg && \
  echo 'deb [signed-by=/usr/share/keyrings/dcm.gpg arch=amd64] https://dcm.dev/debian stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list && \
  apt-get update && \
  apt-get install dcm -y

COPY --chmod=777 ../.devcontainer/mobile/container-mobile-post-create.sh /immich-devcontainer/container-mobile-post-create.sh

RUN dart --disable-analytics

# server production build
FROM dev AS prod

COPY --chown=node:node i18n ./i18n
COPY --chown=node:node server ./server
COPY --chown=node:node open-api ./open-api
COPY --chown=node:node cli ./cli
COPY --chown=node:node web ./web

RUN cd /usr/src/app/open-api/typescript-sdk && \
  npm ci && \
  npm run build && \
  cd /usr/src/app/cli && \
  npm ci && \
  npm run build && \
  cd /usr/src/app/web && \
  npm ci && \
  npm run build && \
  cd /usr/src/app/server && \
  npm ci && \
  npm run build

# prod build
FROM ghcr.io/immich-app/base-server-prod:202505061115@sha256:9971d3a089787f0bd01f4682141d3665bcf5efb3e101a88e394ffd25bee4eedb

WORKDIR /usr/src/app
ENV NODE_ENV=production \
  NVIDIA_DRIVER_CAPABILITIES=all \
  NVIDIA_VISIBLE_DEVICES=all

RUN mkdir -p /usr/src/app/upload && \
  chown -R node:node /usr/src/app && \
  chmod 755 /usr/src/app

COPY --from=prod /usr/src/app/server/node_modules ./node_modules
COPY --from=prod /usr/src/app/server/dist ./dist
COPY --from=prod /usr/src/app/server/bin ./bin
COPY --from=prod /usr/src/app/cli/dist ./cli
COPY --from=prod /usr/src/app/web/build /build/www
COPY docker/scripts/get-cpus.sh \
  ./server/start.sh \
  ./server/package.json \
  ./
COPY LICENSE /licenses/LICENSE.txt
COPY LICENSE /LICENSE

RUN echo '#!/usr/bin/env node' > /usr/src/app/bin/immich && \
  echo 'require("../cli/index.js");' >> /usr/src/app/bin/immich && \
  chmod +x /usr/src/app/bin/immich

ENV PATH="${PATH}:/usr/src/app/bin"

ARG BUILD_ID
ARG BUILD_IMAGE
ARG BUILD_SOURCE_REF
ARG BUILD_SOURCE_COMMIT

ENV IMMICH_BUILD=${BUILD_ID}
ENV IMMICH_BUILD_URL=https://github.com/immich-app/immich/actions/runs/${BUILD_ID}
ENV IMMICH_BUILD_IMAGE=${BUILD_IMAGE}
ENV IMMICH_BUILD_IMAGE_URL=https://github.com/immich-app/immich/pkgs/container/immich-server
ENV IMMICH_REPOSITORY=immich-app/immich
ENV IMMICH_REPOSITORY_URL=https://github.com/immich-app/immich
ENV IMMICH_SOURCE_REF=${BUILD_SOURCE_REF}
ENV IMMICH_SOURCE_COMMIT=${BUILD_SOURCE_COMMIT}
ENV IMMICH_SOURCE_URL=https://github.com/immich-app/immich/commit/${BUILD_SOURCE_COMMIT}

VOLUME /usr/src/app/upload
EXPOSE 2283
ENTRYPOINT ["tini", "--", "/bin/bash"]
CMD ["start.sh"]

HEALTHCHECK CMD immich-healthcheck

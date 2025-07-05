# dev build
FROM ghcr.io/immich-app/base-server-dev:commit-95312641aeba3ecaab9d73d05ca5d9746ab633b6 AS dev

ENV COREPACK_ENABLE_AUTO_PIN=0 \
  COREPACK_ENABLE_DOWNLOAD_PROMPT=0 \
  CI=1

RUN echo "umask 000" >> /etc/profile && \
  echo "umask 000" >> /etc/bash.bashrc && \
  umask 000 && \
  corepack enable && \
  corepack install -g pnpm && \
  apt-get update && \
  apt-get install --no-install-recommends -yqq tini make && \
  rm -rf /var/lib/apt/lists && \
  rm -rf /usr/src/app && \
  mkdir -p /usr/src/app

WORKDIR /usr/src/app
COPY ./server ./server/
COPY Makefile ./package* ./pnpm* ./

RUN umask 000 && mkdir -p /buildcache/pnpm-store && \
  pnpm config set store-dir /buildcache/pnpm-store && \
  SHARP_IGNORE_GLOBAL_LIBVIPS=true make setup-server-dev

ENV PATH="${PATH}:/usr/src/app/bin" \
  IMMICH_ENV=development \
  NVIDIA_DRIVER_CAPABILITIES=all

ENTRYPOINT ["tini", "--", "/bin/sh"]

FROM dev AS dev-container-server

RUN apt-get update && \
  apt-get install sudo inetutils-ping openjdk-11-jre-headless \
  vim nano -y --no-install-recommends --fix-missing && \
  rm -rf /var/lib/apt/lists
RUN usermod -aG sudo node && \
  echo "node ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
  # create workspaces dirs
  mkdir -p /workspaces/immich && \
  mkdir /immich-devcontainer;

WORKDIR /workspaces/immich
# Remove app dir from dev container
RUN rm -rf /usr/src/app

COPY --chmod=777 ../.devcontainer/server/*.sh /immich-devcontainer/

WORKDIR /workspaces/immich

FROM dev-container-server AS dev-container-mobile

USER root
# Enable multiarch for arm64 if necessary
RUN if [ "$(dpkg --print-architecture)" = "arm64" ]; then \
  sudo dpkg --add-architecture amd64 && \
  sudo apt-get install -y --no-install-recommends \
  qemu-user-static \
  libc6:amd64 \
  libstdc++6:amd64 \
  libgcc1:amd64 && \
  rm -rf /var/lib/apt/lists; \
  fi

# Flutter SDK
# https://flutter.dev/docs/development/tools/sdk/releases?tab=linux
ENV FLUTTER_CHANNEL="stable"
ENV FLUTTER_VERSION="3.29.3"
ENV FLUTTER_HOME=/flutter
ENV PATH=${PATH}:${FLUTTER_HOME}/bin

# Flutter SDK
RUN mkdir -p ${FLUTTER_HOME} \
  && curl -C - --output flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/${FLUTTER_CHANNEL}/linux/flutter_linux_${FLUTTER_VERSION}-${FLUTTER_CHANNEL}.tar.xz \
  && tar -xf flutter.tar.xz --strip-components=1 -C ${FLUTTER_HOME} \
  && rm flutter.tar.xz \
  && chown -R node ${FLUTTER_HOME}

RUN wget -qO- https://dcm.dev/pgp-key.public | gpg --dearmor -o /usr/share/keyrings/dcm.gpg \
  && echo 'deb [signed-by=/usr/share/keyrings/dcm.gpg arch=amd64] https://dcm.dev/debian stable main' | tee /etc/apt/sources.list.d/dart_stable.list \
  && apt-get update \
  && apt-get install dcm -y && \
  && rm -rf /var/lib/apt/lists

COPY --chmod=777 ../.devcontainer/mobile/container-mobile-post-create.sh /immich-devcontainer/container-mobile-post-create.sh

RUN dart --disable-analytics
USER node

# server production build
FROM dev AS server-prod

RUN pnpm --filter immich install --frozen-lockfile && \
  pnpm --filter immich build && \
  pnpm --filter immich --prod --no-optional deploy /output/server-pruned

# web production build
FROM dev AS web-prod

COPY ./open-api/typescript-sdk ./open-api/typescript-sdk/
COPY ./web ./web/
COPY ./i18n ./i18n/
RUN pnpm install --filter @immich/sdk --filter immich-web --frozen-lockfile && \
  pnpm --filter @immich/sdk build && \
  pnpm --filter immich-web build

FROM dev AS cli-prod

COPY ./cli ./cli/
COPY ./open-api/typescript-sdk ./open-api/typescript-sdk/
RUN pnpm install --filter @immich/sdk --filter @immich/cli --frozen-lockfile && \
  pnpm --filter @immich/sdk build && \
  pnpm --filter @immich/cli build && \
  pnpm --filter @immich/cli --prod --no-optional deploy /output/cli-pruned

# prod build
FROM ghcr.io/immich-app/base-server-prod:commit-95312641aeba3ecaab9d73d05ca5d9746ab633b6

ENV NODE_ENV=production \
  NVIDIA_DRIVER_CAPABILITIES=all \
  NVIDIA_VISIBLE_DEVICES=all \
  COREPACK_ENABLE_DOWNLOAD_PROMPT=0

RUN corepack enable && \
  corepack install -g pnpm && \
  mkdir -p /usr/src/app/upload

WORKDIR /usr/src/app
COPY --from=server-prod /output/server-pruned/dist ./dist
COPY --from=server-prod /output/server-pruned/bin ./bin
COPY --from=server-prod /output/server-pruned/package.json ./
COPY --from=server-prod /output/server-pruned/node_modules/ ./node_modules
COPY --from=web-prod /usr/src/app/web/build /build/www
COPY --from=cli-prod /output/cli-pruned ./cli
RUN ln -S ./cli/bin/immich /usr/src/app/bin/immich
COPY server/resources ./resources/
COPY server/start*.sh docker/scripts/get-cpus.sh ./
COPY LICENSE /licenses/LICENSE.txt
COPY LICENSE /LICENSE

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

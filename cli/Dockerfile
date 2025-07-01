FROM node:22.16.0-alpine3.20@sha256:2289fb1fba0f4633b08ec47b94a89c7e20b829fc5679f9b7b298eaa2f1ed8b7e AS core

WORKDIR /usr/src/app

COPY --chown=node:node open-api ./open-api
COPY --chown=node:node cli ./cli

RUN cd /usr/src/app/open-api/typescript-sdk && \
  npm ci && \
  npm run build && \
  cd /usr/src/app/cli && \
  npm ci && \
  npm run build && \
  npm prune --omit dev --omit optional && \
  rm -rf src eslint* package-lock* tsconfig* vite*

WORKDIR /import

ENTRYPOINT ["node", "/usr/src/app/cli/dist"]

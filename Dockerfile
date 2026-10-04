FROM node:24 AS construccion

WORKDIR /usr/app

# Instalamos pnpm globalmente para no depender de la descarga de Corepack
RUN npm install -g pnpm

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
RUN pnpm install --frozen-lockfile

COPY nest-cli.json tsconfig*.json ./
COPY src ./src

RUN pnpm build

FROM node:24 AS dependencias-produccion

WORKDIR /usr/app

RUN npm install -g pnpm

COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
RUN pnpm install --prod --frozen-lockfile

FROM node:24-alpine AS runner

WORKDIR /usr/app

COPY --from=construccion /usr/app/package.json ./
COPY --from=construccion /usr/app/dist ./dist
COPY --from=dependencias-produccion /usr/app/node_modules ./node_modules

CMD ["node", "dist/main.js"]

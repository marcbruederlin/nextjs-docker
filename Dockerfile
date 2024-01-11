# Target base
FROM node:21-alpine AS base

ENV NEXT_TELEMETRY_DISABLED 1

RUN apk add --no-cache libc6-compat

WORKDIR /app

COPY package.json yarn.lock* ./

EXPOSE 3000

# Target dependencies
FROM base AS dependencies

RUN yarn install --production && \
    cp -R node_modules /prod_node_modules && \
    yarn install --production=false

# Target builder
FROM base AS builder

COPY --from=dependencies /app/node_modules /app/node_modules
COPY . /app

RUN yarn build && \
    rm -rf node_modules

# Target development
FROM dependencies AS development

ENV NODE_ENV development

COPY . /app

CMD [ "yarn", "dev" ]

# Target production
FROM base AS production

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs
RUN mkdir .next
RUN chown nextjs:nodejs .next

COPY --from=builder /app/public /app/public
COPY --from=builder /app/.next /app/.next
COPY --from=dependencies /prod_node_modules /app/node_modules

USER nextjs

CMD [ "yarn", "start" ]

HEALTHCHECK --interval=5s --timeout=5s --retries=3 \
    CMD curl --fail http://localhost:3000 || exit 1
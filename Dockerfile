FROM node:14-alpine AS BuildBot
WORKDIR /usr/src/bot
COPY package.json .
COPY yarn.lock .
COPY tsconfig.json .
RUN yarn install
COPY . .
RUN yarn run build

FROM node:14-alpine
WORKDIR /usr/src/bot
COPY package.json .
COPY yarn.lock .
RUN yarn install --production
COPY --from=BuildBot /usr/src/bot/dist .
ENV NODE_ENV production
ENV PORT 80
EXPOSE 80
CMD ["node", "index.js"]

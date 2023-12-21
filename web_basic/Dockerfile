FROM node:18-alpine

WORKDIR /app

COPY package.json ./

RUN npm install && npm cache clean --force

COPY . /app

CMD ["node", "server.js"]

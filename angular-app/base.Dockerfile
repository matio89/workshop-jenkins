FROM node:8.11.2-alpine as node

WORKDIR /usr/src/app

COPY package.json ./

RUN npm i npm@latest -g

RUN npm install

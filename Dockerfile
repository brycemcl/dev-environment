FROM node:lts
ENV NODE_ENV=production
WORKDIR /usr/src/app
COPY ["package.json", "package-lock.json*", "npm-shrinkwrap.json*", "./"]
RUN npm install --production --silent
COPY ./src ./src
EXPOSE 3000
CMD ["node", "src/index.js"]

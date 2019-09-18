FROM node

WORKDIR /SC-test
COPY package.json ./

RUN echo "151.101.4.162 registry.npmjs.org" >> /etc/hosts && npm install --no-save --production
RUN npm install
COPY . .

EXPOSE 8080

CMD ["npm", "start"]


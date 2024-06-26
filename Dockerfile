FROM node:21

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

EXPOSE 4444
CMD ["node", "index.js"]

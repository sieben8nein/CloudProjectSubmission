FROM node:15.4.0

COPY Backend/ /app
WORKDIR /app
COPY ./Backend/package*.json ./
EXPOSE 3000

RUN npm install

CMD ["npm", "start"]

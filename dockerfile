# --------------------------
# build react app
# --------------------------
FROM node:15-alpine as builder

# set working directory
WORKDIR /app

# add environment variables
ARG API_HOST=l1nus.duckdns.org
ARG API_PORT=4000
ENV REACT_APP_API_HOST=$API_HOST \
    REACT_APP_API_PORT=$API_PORT

# add dependencies
COPY ./app/package*.json ./

# install dependencies
RUN npm install react-scripts@4.0.0 -g --silent
RUN npm install --silent

# add app
COPY ./app/public ./public
COPY ./app/src ./src

# build app
RUN npm run build

# --------------------------
# build fastify and run image
# --------------------------
FROM node:15-alpine

ENV PORT=3000

# set working directory
WORKDIR /app

COPY --from=builder /app/build ./build

# add dependencies
COPY ./server/package*.json ./

# install dependencies
RUN npm install --silent

# add app
COPY ./server/app.js .

# start app
CMD ["node", "app.js"]

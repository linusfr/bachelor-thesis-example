# --------------------------
# build react app
# --------------------------
FROM node:15-alpine as builder

# set working directory
WORKDIR /app

# add environment variables
ARG API_HOST=linusfr.duckdns.org \
    API_PORT=4000
ENV REACT_APP_API_HOST=$API_HOST \
    REACT_APP_API_PORT=$API_PORT

# add dependencies
COPY ./app/package*.json ./

# install dependencies
RUN npm install react-scripts@4.0.0 -g --silent && npm install --silent

# add app
COPY ./app/public ./public
COPY ./app/src ./src

# build app
RUN npm run build

# --------------------------
# build fastify and run image
# --------------------------
FROM node:15-alpine

# port for the fastify server to listen on
ENV PORT=3000

# database information
ENV PGHOST=db
ENV PGPORT=5432
ENV PGDATABASE=cats
ENV PGUSER=demo
ENV PGPASSWORD=secure_password

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

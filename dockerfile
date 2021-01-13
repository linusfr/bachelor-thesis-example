# --------------------------
# build react app
# --------------------------
FROM node:15-alpine as builder

# set working directory
WORKDIR /app

# add environment variables
ARG API_HOST \
    API_PORT
    
ENV REACT_APP_API_HOST=$API_HOST \
    REACT_APP_API_PORT=$API_PORT

# add dependencies
COPY ./app/package*.json ./

# install dependencies
RUN npm install react-scripts@4.0.0 -g --silent && \
    npm install --silent

# add app
COPY ./app/public ./public
COPY ./app/src ./src

# build app
RUN npm run build

# --------------------------
# build fastify and run image
# --------------------------
FROM node:15-alpine

# database information
ENV PGHOST \  
    PGPORT \
    PGDATABASE \
    PGUSER \
    PGPASSWORD \
    # port for the fastify server to listen on
    PORT

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

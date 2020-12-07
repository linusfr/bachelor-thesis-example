# --------------------------
# build react app
# --------------------------
FROM node:15.2.0-alpine3.10

# set working directory
WORKDIR /app

# add environment variables
ARG API_HOST
ENV REACT_APP_API_HOST $API_HOST
ARG API_PORT
ENV REACT_APP_API_PORT $API_PORT

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

# add dependencies
COPY ./app/package.json .
COPY ./app/package-lock.json .

# install dependencies
RUN npm install --silent
RUN npm install react-scripts@4.0.0 -g --silent

# add app
COPY ./app/public ./public
COPY ./app/src ./src

# build app
RUN npm run build

# --------------------------
# build fastify
# --------------------------
FROM node:15.2.0-alpine3.10

# set working directory
WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
ENV PATH /app/node_modules/.bin:$PATH

COPY --from=0 /app/build ./build

# add dependencies
COPY ./server/package.json .
COPY ./server/package-lock.json .

# install dependencies
RUN npm install --silent

# add app
COPY ./server/app.js .

# --------------------------
# start fastify
# --------------------------

# start app
CMD ["node", "app.js"]

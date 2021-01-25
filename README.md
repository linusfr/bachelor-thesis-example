# bachelor-thesis-example

This directory consists of five directories:

1. the react client (app)
2. the fastify webserver (server)
3. the kubernetes yamls (kubernetes)
4. the swarm mode yamls (swarm)
5. the sql script for the postgres (sql) used by both kubernetes and the swarm mode

The dockerfile uses the directories "app" and "server".  
The image created by building the dockerfile is used in the deployments in the directories "swarm" and "kubernetes".

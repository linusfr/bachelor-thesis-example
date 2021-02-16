# bachelor-thesis-example

This directory consists of five directories:

1. the react client (app)
2. the fastify webserver (server)
3. the kubernetes yamls (kubernetes)
4. the swarm mode yamls (swarm)
5. the sql script for the postgres (sql) used by both kubernetes and the swarm mode

The dockerfile uses the directories "app" and "server".  
The image created by building the dockerfile is used in the deployments in the directories "swarm" and "kubernetes".

# clean up

## swarm

```
docker stack rm cats
docker volume rm cats_postgres-data
```

## kubernetes

```
kubectl delete -f .
kubectl delete configmap cats-init-script
kubectl delete pvc postgres-volume-postgres-statefulset-0
kubectl delete job backup-job
```

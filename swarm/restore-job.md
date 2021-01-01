```
docker service create   --name restore-cats \
                        --mode replicated-job \
                        --replicas 1 \
                        --max-concurrent 1 \
                        --network cats_default \
                        --env PGUSER=demo \
                        --env PGPASSWORD=hcFWQgb5gDJA4EWw8Sp7 \
                        --env PGHOST=db \
                        --env PGDATABASE=cats \
                        --mount 'type=volume,dst=/backup,volume-driver=local,volume-opt=type=nfs,volume-opt=device=:/srv/nfs/postgres-backup-cats-swarm,"volume-opt=o=addr=192.168.178.35,nfsvers=4,rw"' \
                          postgres:alpine bash -c 'echo "*:*:*:*:${PGPASSWORD}" > ~/.pgpass && chmod 0600 ~/.pgpass && pg_restore --verbose --no-owner --clean --if-exists --dbname=${PGDATABASE} /backup/${PGDATABASE}.sql.gz'
```

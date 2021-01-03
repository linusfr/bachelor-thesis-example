docker service create   --name restore-cats \
                        --mode replicated-job \
                        --replicas 1 \
                        --max-concurrent 1 \
                        --network cats_default \
                        --env PGHOST=db \
                        --config cats_postgres-user \
                        --config cats_postgres-db \
                        --secret cats_postgres-password \
                        --mount 'type=volume,dst=/backup,volume-driver=local,volume-opt=type=nfs,volume-opt=device=:/srv/nfs/postgres-backup-cats-swarm,"volume-opt=o=addr=192.168.178.35,nfsvers=4,rw"' \
                          postgres:alpine bash -c 'export PGUSER=$(cat /cats_postgres-user) PGDATABASE=$(cat /cats_postgres-db) && echo "*:*:*:*:$(cat /run/secrets/cats_postgres-password)" > ~/.pgpass \
                            && chmod 0600 ~/.pgpass \
                            && pg_restore \
                              --verbose \
                              --no-owner \
                              --clean \
                              --if-exists \
                              --dbname=${PGDATABASE} /backup/${PGDATABASE}.sql.gz'

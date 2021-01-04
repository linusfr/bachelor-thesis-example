docker service create   --name restore-cats \
                        --mode replicated-job \
                        --replicas 1 \
                        --max-concurrent 1 \
                        --network cats_cats \
                        --env PGHOST=db \
                        --config cats_postgres-user \
                        --config cats_postgres-db \
                        --secret cats_postgres-password \
                        --mount 'type=volume,dst=/backup,volume-driver=local,volume-opt=type=nfs,volume-opt=device=:/srv/nfs/postgres-backup-cats-swarm,"volume-opt=o=addr=192.168.178.35,nfsvers=4,rw"' \
                        postgres:alpine sh -c '
                          PGPASSWORD=$(</run/secrets/cats_postgres-password) \
                          pg_restore \
                            --username=$(</cats_postgres-user) \
                            --verbose \
                            --no-owner \
                            --clean \
                            --if-exists \
                            --dbname=$(</cats_postgres-db) /backup/$(</cats_postgres-db).sql.gz'
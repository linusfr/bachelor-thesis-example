# 1

```
kubectl create configmap cats-init-script --from-file ../sql/cats.sql
```

# Postgres Steps

## dumpen

```
pg_dump --verbose --format=custom --no-owner --file=/mnt/backup/element-lns.sql.gz element-lns
pg_dump --verbose --format=custom --no-owner --file=/mnt/backup/example-database.sql.gz example-database
```

## restore

```
pg_restore --schema-only  --clean --if-exists --no-owner --dbname=element-lns /mnt/backup/element-lns.sql.gz
pg_restore --data-only --disable-triggers --no-owner --dbname=element-lns /mnt/backup/element-lns.sql.gz
pg_restore --schema-only  --clean --if-exists --no-owner --dbname=example-database /mnt/backup/example-database.sql.gz
pg_restore --data-only --disable-triggers --no-owner --dbname=example-database /mnt/backup/example-database.sql.gz
```

## user permissions

```
create user 'example-database' with encrypted password 'mypassword';
grant all privileges on database 'example-database' to 'example-database';
create user 'element-lns' with encrypted password 'myOtherpassword';
grant all privileges on database 'element-lns' to 'element-lns';
```

# create secret

```
echo -n "admin" | base64
```

# nfs

## server

1. install

```
sudo apt install nfs-kernel-server -y
```

2. create directory to be hosted

```
mkdir /path/backup -p
```

3. give clients permissions on created directory

```
sudo chown nobody:nogroup /path/backup
```

4. create nfs config and add permissions for the desired clients and directories

```
echo "/path/backup node_ip(rw,sync,no_subtree_check)" | sudo tee -a /etc/exports
```

5. restart nfs server to apply config changes

```
sudo systemctl restart nfs-kernel-server
```

That's it on the server side of things.

## client

1. install

```
sudo apt install nfs-common -y
```

2. mount volume

```
sudo mount nfs_server_ip:/path/backup /desired_local_path
```

3. do stuff with it
4. unmount the volume

```
sudo umount /desired_local_path
```

## ressources

```
https://matthewpalmer.net/kubernetes-app-developer/articles/kubernetes-volumes-example-nfs-persistent-volume.html
https://www.howtoforge.de/anleitung/wie-man-nfs-client-und-server-unter-ubuntu-2004-installiert/
https://help.ubuntu.com/community/NFSv4Howto#NFSv4_with_Kerberos
```

# kustomize

## usage

With customize you can define yamls as a base which can be modified through overlays.
You can create any number of overlays.

> simple example: https://blog.viadee.de/kubernetes-deployments-mit-kustomize#overlays

## implementation

In the following version kustomize is implemented for demo purposes.
The implementation uses two overlays upon a postgres basis.
One creates a database for dogs and the other one a database for cats.

> kustomize-demo: https://git.zisops.com/devops/k3s/-/tags/kustomize-demo

## problems for Kustomize v2.0.3

During the implementation of the demo we encountered two-problems.

1. Naming of Objects  
   We have this Issue:
    > https://github.com/kubernetes-sigs/kustomize/issues/149

Which has been fixed by:

> https://github.com/kubernetes-sigs/kustomize/pull/150

And has been merged into master here:

> https://github.com/kubernetes-sigs/kustomize/commit/3305be958942e7fd84536af6ab4e5ec0d11bd2fe

Lastly the fix as a part of the release v3.3.1:

> https://github.com/kubernetes-sigs/kustomize/releases/tag/v3.3.1

The problem still exists in the kustomization version bundled with kubectl since kubectl only comes bundled with kustomize v2.0.3

> https://github.com/kubernetes-sigs/kustomize#kubectl-integration

2. Job Kustomization  
   The second problem we discovered lies in the customization of a job.  
   Just like we want to reuse yaml as part of a base to build overlays upon it we want to be able to build a generic job which can be altered to fit a project you want to use it in.  
   But in the current features we did not find a good option for that.  
   The best solution we found is implemented in the following commit:
    > commit: https://git.zisops.com/devops/k3s/-/tree/89d43ce57e8aa99a98325c60cea974f3978a5dd8

In that solution we created a base and overlays for each job. This way you can kustomize and apply each job for any necessary overlay individually.  
This does require a lot of hierachy not desirable for smaller projects.

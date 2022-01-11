# Microserver Docker Configurations

## Setup instructions

### Obtain files

* Download this repository to /ctr_cfg on the docker host
* Obtain the last backup from cloud storage, and extract to the same location

### User and Group

The following user and group need to be created so that the container permissions are correct:
* ctrdata - 9001

All docker images should be configured to run as that user

Once that is done, run fix-permissions.sh to ensure the file permissions are correct

### Network

A docker network needs to be configured to ensure that all containers can see each other. To create the network:

```
docker network create -d bridge ctr-network
```

### Network Volumes
Before the containers can be created, the docker volumes need to be created. The following need to be created as NFS volumes:
* nfs_downloads
* nfs_media
* nfs_watch

The command for creating an NFS volume is:

```
docker volume create --driver local \
  --opt type=nfs \
  --opt o=nfsvers=4,addr=<address>,rw \
  --opt device=:<shared directory> \
  <volume name>
```

### Config Volumes
All of the configuration is stored on a local mount volume. This is because backing up and restoring mounted volumes is much easier than docker managed volumes.

All config is stored under /ctr_cfg, and can be obtained by extracting the data from the last backup.

### Other

Note: ENV files are not present and need to be copied from secure cloud storage

## TODO

Write ansible scripts to automate this process
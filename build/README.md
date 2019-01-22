# salt-master


## Getting Started

Requirements:
- manifest-tool https://github.com/estesp/manifest-tool
- salt-bootstrap https://github.com/saltstack/salt-bootstrap
- Docker https://docker.com



### Building

#### Environment Variables

WARNING: NO DEFAULTS
`IMAGE` - Used to set the Docker container image. Following have been tested:
  * debian:8 (used regardless by armhf)
  * debian:9
  * ubuntu:16.04
  * ubuntu 18.04
  
`EMAIL` - Maintainer Email

`REPO_NAME` - Docker Hub Repo

`VERSION_IMAGE_TAG` - SaltStack Version

`JENKINS` - Set to TRUE if you don't want to supply interactive answer

#### Build Script

```
$ ./build.sh build
```

Deploy:

```
$ ./build deploy
```

#### Manual Build/Deploy

```
$ docker build --build-arg IMAGE=debian:9 --build-arg EMAIL=example@example.email  -t example/salt-master:master .
$ docker docker tag example/salt-master:master  example/salt-master:latest
$ docker push example/salt-master:latest
```

#### Multi-Architecture 

Requires manifest-tool:

```
manifest-tool push from-spec ./manifest.yml
```

### Bugs/Feedback

Please open an issue at https://github.com/zfouts/docker-saltmaster/issues

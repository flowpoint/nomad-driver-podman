Nomad podman Driver
==================


[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://github.com/pascomnet/nomad-driver-podman/blob/master/LICENSE)
[![CircleCI](https://circleci.com/gh/pascomnet/nomad-driver-podman.svg?style=shield)](https://circleci.com/gh/pascomnet/nomad-driver-podman)


*THIS IS A PROOF OF CONCEPT PLUGIN*. Do not run it in production!
Contributions are welcome, of course.

## Building The Driver

This project has a go.mod definition. So you can clone it to whatever directory you want.
It is not necessary to setup a go path at all.

```sh
$ git clone git@github.com:pascomnet/nomad-driver-podman
cd nomad-driver-podman
./build.sh
```

## Runtime dependencies

- [Nomad](https://www.nomadproject.io/downloads.html) 0.9+
- Linux host with `podman` installed

You need a varlink enabled podman binary and a system socket activation unit,
see https://podman.io/blogs/2019/01/16/podman-varlink.html. 

nomad agent, nomad-driver-podman and podman will reside on the same host, so you 
do not have to worry about the ssh aspects of podman varlink.

Ensure that nomad can find the plugin, see [plugin_dir](https://www.nomadproject.io/docs/configuration/index.html#plugin_dir)

## Using the driver

The featureset is very limited. 
For now you can:

* use the jobs driver config to define the image for your container
* start/stop containers. 
* use nomad alloc data in the container. It's bind mounted to /nomad
* monitor the memory consuption
* monitor CPU usage (might be buggy)
* container memory is limited to configured value
* task config cpu value is used to populate podman CpuShares


### Task Configuration

* **image** - The image to run, 

```
config {
  image = "docker://redis"
}
```

* **command** - (Optional) The command to run when starting the container.

```
config {
  command = "some-command"
}
```

* **args** - (Optional) A list of arguments to the optional command. If no *command* is specified, the arguments are passed directly to the container.

```
config {
  args = [
    "arg1",
    "arg2",
  ]
}
```

## Example job

```
job "redis" {
  datacenters = ["dc1"]
  type        = "service"

  group "redis" {
    task "redis" {
      driver = "podman"

        config {
          image = "docker://redis"
        }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
```

```sh
nomad run redis.nomad

==> Monitoring evaluation "9fc25b88"
    Evaluation triggered by job "redis"
    Allocation "60fdc69b" created: node "f6bccd6d", group "redis"
    Evaluation status changed: "pending" -> "complete"
==> Evaluation "9fc25b88" finished with status "complete"

podman ps

CONTAINER ID  IMAGE                           COMMAND               CREATED         STATUS             PORTS  NAMES                                                                              
6d2d700cbce6  docker.io/library/redis:latest  docker-entrypoint...  16 seconds ago  Up 16 seconds ago         redis-60fdc69b-65cb-8ece-8554-df49321b3462
```

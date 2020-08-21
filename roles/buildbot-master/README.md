buildbot-master
=========

Create and run a container for a Buildbot worker to build NTEL Orion images.

Requirements
------------

Requires a host running a Docker-compatible engine. A Buildbot master instance
should also be accessible for this worker.

Role Variables
--------------

### Image Configuration
| `buildbot_image_args`        | arguments for building the Docker image                              |
| `buildbot_image_dir`         | directory from which to build the Docker image                       |
| `buildbot_image_name`        | name:tag for the built image                                         |
| `buildbot_image_repo`        | sources for the image; installed in `buildbot_image_dir`      |

### Container Configuration
| `buildbot_container`         | defines the container's name                                         |
| `buildbot_env`               | defines the container's environment                                  |
| `buildbot_hostname`          | defines the container's hostname                                     |
| `buildbot_networks`          | defines the container's networks                                     |
| `buildbot_port_args`         | defines the container's published ports                              |
| `buildbot_restart_policy`    | how the container should restart upon errors |
| `buildbot_version`           | specifies the buildbot worker's version                              |
| `buildbot_cache_volume`      | defines the volume bound to `buildbot_cache_path`             |
| `buildbot_hostdir_config`    | defines a directory on the host to store config files for the worker |
| `buildbot_volume_data`       | defines the volume bound to `buildbot_data_path`              |
| `buildbot_volumes`           | defines a list of volumes to mount in the container                  |

### Buildbot Worker Configuration
| `buildbot_http_port`         | port number for unencrypted web access |
| `buildbot_https_port`        | port number for encrypted web access |
| `buildbot_connection_string` | Twisted library connection string for worker to contact master       |
| `buildbot_worker_port`       | port number for workers to communicate with master |

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables
passed in as parameters) is always nice for users too:

    - hosts: servers
      tasks:
        - name: start the buildbot worker
          import_role:
            name: buildbot-worker-ntel
          vars:
            variant: '-suffix'
            variant_var_prefix: 'buildbot_prefix'
          tags:
            - buildbot-worker-suffix

License
-------

MIT

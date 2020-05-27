buildbot-worker-ntel
=========

Create and run a container for a Buildbot worker to build NTEL Orion images.

Requirements
------------

Requires a host running a Docker-compatible engine. A Buildbot master instance
should also be accessible for this worker.

Role Variables
--------------

### Image Configuration
| `buildbot_worker_image_args`        | arguments for building the Docker image                              |
| `buildbot_worker_image_dir`         | directory from which to build the Docker image                       |
| `buildbot_worker_image_name`        | name:tag for the built image                                         |
| `buildbot_worker_image_repo`        | sources for the image; installed in `buildbot_worker_image_dir`      |

### Container Configuration
| `buildbot_worker_container`         | defines the container's name                                         |
| `buildbot_worker_env`               | defines the container's environment                                  |
| `buildbot_worker_hostname`          | defines the container's hostname                                     |
| `buildbot_worker_networks`          | defines the container's networks                                     |
| `buildbot_worker_port_args`         | defines the container's published ports                              |
| `buildbot_worker_version`           | specifies the buildbot worker's version                              |
| `buildbot_worker_volume_cache`      | defines the volume bound to `buildbot_worker_cache_path`             |
| `buildbot_worker_hostdir_config`    | defines a directory on the host to store config files for the worker |
| `buildbot_worker_volume_data`       | defines the volume bound to `buildbot_worker_data_path`              |
| `buildbot_worker_volumes`           | defines a list of volumes to mount in the container                  |

### Buildbot Worker Configuration
| `asset_downloads`                   | url from which the worker should download assets for builds          |
| `buildbot_worker_connection_string` | Twisted library connection string for worker to contact master       |
| `hsm_host`                          | hostname of cryptographic signing server                             |

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
            variant_var_prefix: 'buildbot_worker_prefix'
          tags:
            - buildbot-worker-suffix

License
-------

MIT

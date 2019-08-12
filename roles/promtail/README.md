Ansible Role: PromTail
==================

Starts a Docker container for an instance of Promtail, a log file watcher and parser.

Requirements
------------

This role assumes a host running the Docker engine.

To be effective, a Loki instance should also be available to receive parsed log entries.

A Grafana instance should

Loki can receive logs from several sources, but Promtail is used to gather logs from files and deliver them to Loki.

Role Variables
--------------

Default variables are listed below.

### Docker Container Settings
These variables configure the container itself, like the version of the image
used or environment variables set inside.

| Name           | Description                        |
| -------------- | -----------------------------------|
| `promtail_version` | should be set to _latest_ or to a tag defined on [Docker Hub](https://hub.docker.com/r/grafana/promtail/tags) |
| `promtail_command` | defines the command line arguments passed to the application |
| `promtail_container` | defines the name of the container to access it via the command line or its internal Docker network |
| `promtail_env` | provides variables into the container's environment. |
| `promtail_hostname` | hostname a container uses for itself. |
| `promtail_image` | defines the Docker image to instantiate. Override this to use a custom image i.e. different from the official one on Docker Hub. |
| `promtail_networks` | defines any Docker networks onto which this container should attach. Defaults to the Docker default bridge network. |
| `promtail_port_args` | defines any network ports that should be bound onto the host. |
| `promtail_restart_policy` | defines when Docker should restart this container. |

### Docker Volume Settings

| Name           | Description                        |
| -------------- | -----------------------------------|
| `promtail_etc_volume` | Host-side directory for promtail configuration |
| `promtail_storage_volume` | Named volume for promtail data storage |
| `promtail_volumes` | Container volume mount definitions |

### Loki Application Configuration

Variables used to configure the Loki application running within the container. The entire configuration file is YAML, with each major section broken into variables.

| Name           | Description                        |
| -------------- | -----------------------------------|
| `promtail_server_config`    | configures Promtail's behavior as an HTTP server [Reference](https://github.com/grafana/loki/blob/v1.4.1/docs/clients/promtail/configuration.md#server_config) |
| `promtail_client_configs`   | configures how Promtail connects to an instance of Loki [Reference](https://github.com/grafana/loki/blob/v1.4.1/docs/clients/promtail/configuration.md#client_config) |
| `promtail_positions_config` | configures where Promtail will save a file indicating how far it has read into a file [Reference](https://github.com/grafana/loki/blob/v1.4.1/docs/clients/promtail/configuration.md#position_config) |
| `promtail_scrape_configs`   | configures how Promtail can scrape logs from a series of targets [Reference](https://github.com/grafana/loki/blob/v1.4.1/docs/clients/promtail/configuration.md#scrape_config) |
| `promtail_target_config`    | controls the behavior of reading files from discovered targets [Reference](https://github.com/grafana/loki/blob/v1.4.1/docs/clients/promtail/configuration.md#target_config) |

## Local Testing

The preferred way of locally testing the role is to use Vagrant and [molecule (v3)](https://molecule.readthedocs.io/en/latest/). You will have to install Vagrant and Molecule's Vagrant driver on your system.

To install Vagrant driver execute:
```sh
pip install molecule-vagrant
```
To run tests:
```sh
molecule test
```
For more information about molecule go to their [docs](http://molecule.readthedocs.io/en/latest/).

## License

This project is licensed under MIT License. See [LICENSE](/LICENSE) for more details.

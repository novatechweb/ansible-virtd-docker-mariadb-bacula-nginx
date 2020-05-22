Ansible Role: Loki
==================

Starts a Docker container for an instance of Loki, a multi-tenant log aggregation system.

Requirements
------------

This role assumes a host running the Docker engine.

To be effective, a Grafana instance should also be accessible for exploring and monitoring Loki data.

Loki can receive logs from several sources, but Promtail is used to gather logs from files and deliver them to Loki.

Role Variables
--------------

Default variables are listed below.

### Docker Container Settings
These variables configure the container itself, like the version of the image
used or environment variables set inside.

| Name           | Description                        |
| -------------- | -----------------------------------|
| `loki_version` | should be set to _latest_ or to a tag defined on [Docker Hub](https://hub.docker.com/r/grafana/loki/tags) |
| `loki_command` | defines the command line arguments passed to the application |
| `loki_container` | defines the name of the container to access it via the command line or its internal Docker network |
| `loki_env` | provides variables into the container's environment. |
| `loki_hostname` | hostname a container uses for itself. |
| `loki_image` | defines the Docker image to instantiate. Override this to use a custom image i.e. different from the official one on Docker Hub. |
| `loki_networks` | defines any Docker networks onto which this container should attach. Defaults to the Docker default bridge network. |
| `loki_port_args` | defines any network ports that should be bound onto the host. |
| `loki_restart_policy` | defines when Docker should restart this container. |

### Docker Volume Settings

| Name           | Description                        |
| -------------- | -----------------------------------|
| `loki_etc_volume` | Host-side directory for Loki configuration |
| `loki_storage_volume` | Named volume for Loki data storage |
| `loki_volumes` | Container volume mount definitions |

### Loki Application Configuration

Variables used to configure the Loki application running within the container. The entire configuration file is YAML, with each major section broken into variables.

| Name           | Description                        |
| -------------- | -----------------------------------|
| `loki_target_config` | The module to run Loki with. [Reference](https://github.com/grafana/loki/blob/v1.4.1/docs/configuration/README.md#configuration-file-reference) |
| `loki_auth_enabled_config` | Enables authentication through the X-Scope-OrgID header [Reference](https://github.com/grafana/loki/blob/v1.4.1/docs/configuration/README.md#configuration-file-reference) |
| `loki_server_config` | Configures Loki's behavior as an HTTP server [Reference](https://github.com/grafana/loki/blob/v1.4.1/docs/configuration/README.md#server_config) |
| `loki_distributor_config` | configures the Loki Distributor. [Reference](https://github.com/grafana/loki/blob/v1.4.1/docs/configuration/README.md#distributor_config) |
| `loki_querier_config` | configures the Loki Querier. [Reference](https://github.com/grafana/loki/blob/v1.4.1/docs/configuration/README.md#querier_config) |
| `loki_ingester_client_config` | configures how connections to ingesters operate [Reference](https://github.com/grafana/loki/blob/v1.4.1/docs/configuration/README.md#ingester_config) |
| `loki_ingester_config` | configures Ingesters. [Reference](https://github.com/grafana/loki/blob/v1.4.1/docs/configuration/README.md#ingester_config) |
| `loki_storage_config` | configures one of many possible stores for both the index and chunks [Reference](https://github.com/grafana/loki/blob/v1.4.1/docs/configuration/README.md#storage_config) |
| `loki_chunk_store_config` | configures how chunks will be cached and how long to wait before saving them to the backing store. [Reference](https://github.com/grafana/loki/blob/v1.4.1/docs/configuration/README.md#chunk_store_config) |
| `loki_schema_config` | configures schemas from given dates. [Reference](https://github.com/grafana/loki/blob/v1.4.1/docs/configuration/README.md#schema_config) |
| `loki_limits_config` | configures global and per-tenant limits for ingesting logs  [Reference](https://github.com/grafana/loki/blob/v1.4.1/docs/configuration/README.md#limits_config) |
| `loki_table_manager_config` | configures how the table manager operates  [Reference](https://github.com/grafana/loki/blob/v1.4.1/docs/configuration/README.md#table_manager_config) |

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

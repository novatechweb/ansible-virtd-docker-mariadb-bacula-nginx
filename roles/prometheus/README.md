Ansible Role: Prometheus
=========

Starts a Docker container for an instance of Prometheus, a monitoring and alerting toolkit.

Requirements
------------

This role assumes a host running the Docker engine.

Role Variables
--------------

Default variables are listed below.

### Docker Container Settings
These variables configure the container itself, like the version of the image
used or environment variables set inside.

| Name           | Description                        |
| -------------- | -----------------------------------|
| `prometheus_version` | should be set to _latest_ or to a tag defined on [Quay](https://quay.io/repository/prometheus/prometheus?tag=latest&tab=tags) |
| `prometheus_container` | defines the name of the container to access it via the command line or its internal Docker network |
| `prometheus_env` | provides variables into the container's environment. |
| `prometheus_hostname` | hostname a container uses for itself. |
| `prometheus_image` | defines the Docker image to instantiate. Override this to use a custom image i.e. different from the official one on Docker Hub. |
| `prometheus_networks` | defines any Docker networks onto which this container should attach. Defaults to the Docker default bridge network. |
| `prometheus_port_args` | defines any network ports that should be bound onto the host. |
| `prometheus_restart_policy` | defines when Docker should restart this container. |

### Docker Volume Settings

| Name           | Description                        |
| -------------- | -----------------------------------|
| `prometheus_etc_volume` | Host-side directory for Grafana configuration |
| `prometheus_storage_volume` | Named volume for Grafana data storage |
| `prometheus_volumes` | Container volume mount definitions |

### Prometheus Application Configuration

Variables used to configure the Prometheus application running within the container.

| Name           | Description                        |
| -------------- | -----------------------------------|
| `prometheus_web_listen_address`| Address on which prometheus will be listening |
| `prometheus_web_external_url`| External address on which prometheus is available. Useful when behind reverse proxy. Ex. `http://example.org/prometheus` |
| `prometheus_storage_retention`| Data retention period |
| `prometheus_storage_retention_size`| Data retention period by size |
| `prometheus_config_flags_extra`| Additional configuration flags passed to prometheus binary at startup |
| `prometheus_alertmanager_config`| Configuration responsible for pointing where alertmanagers are. This should be specified as list in yaml format. It is compatible with official [<alertmanager_config>](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#alertmanager_config) |
| `prometheus_alert_relabel_configs`| Alert relabeling rules. This should be specified as list in yaml format. It is compatible with the official [<alert_relabel_configs>](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#alert_relabel_configs) |
| `prometheus_global`| Prometheus global config. Compatible with [official configuration](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#configuration-file) |
| `prometheus_remote_write`| Remote write. Compatible with [official configuration](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#<remote_write>) |
| `prometheus_remote_read`| Remote read. Compatible with [official configuration](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#<remote_read>) |
| `prometheus_external_labels` | Provide map of additional labels which will be added to any time series or alerts when communicating with external systems |
| `prometheus_targets`| Targets which will be scraped. Better example is provided in our [demo site](https://github.com/cloudalchemy/demo-site/blob/2a8a56fc10ce613d8b08dc8623230dace6704f9a/group_vars/all/vars#L8) |
| `prometheus_scrape_configs`| Prometheus scrape jobs provided in same format as in [official docs](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#scrape_config) |
| `prometheus_config_file_template`| Variable used to provide custom prometheus configuration file in form of ansible template |
| `prometheus_alert_rules`| Full list of alerting rules which will be copied to `{{ prometheus_config_dir }}/rules/ansible_managed.rules`. Alerting rules can be also provided by other files located in `{{ prometheus_config_dir }}/rules/` which have `*.rules` extension |
| `prometheus_alert_rules_files` | List of folders where ansible will look for files containing alerting rules which will be copied to `{{ prometheus_config_dir }}/rules/`. Files must have `*.rules` extension |
| `prometheus_static_targets_files` | List of folders where ansible will look for files containing custom static target configuration files which will be copied to `{{ prometheus_config_dir }}/file_sd/`. |

## Relation between `prometheus_scrape_configs` and `prometheus_targets`

#### Short version

`prometheus_targets` is just a map used to create multiple files located in "{{ prometheus_config_dir }}/file_sd" directory. Where file names are composed from top-level keys in that map with `.yml` suffix. Those files store [file_sd scrape targets data](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#file_sd_config) and they need to be read in `prometheus_scrape_configs`.

#### Long version

A part of *prometheus.yml* configuration file which describes what is scraped by prometheus is stored in `prometheus_scrape_configs`. For this variable same configuration options as described in [prometheus docs](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#<scrape_config>) are used.

Meanwhile `prometheus_targets` is our way of adopting [prometheus scrape type `file_sd`](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#<file_sd_config>). It defines a map of files with their content. A top-level keys are base names of files which need to have their own scrape job in `prometheus_scrape_configs` and values are a content of those files.

All this mean that you CAN use custom `prometheus_scrape_configs` with `prometheus_targets` set to `{}`. However when you set anything in `prometheus_targets` it needs to be mapped to `prometheus_scrape_configs`. If it isn't you'll get an error in preflight checks.

#### Example

Lets look at our default configuration, which shows all features. By default we have this `prometheus_targets`:
```yaml
prometheus_targets:
  node:  # This is a base file name. File is located in "{{ prometheus_config_dir }}/file_sd/<<BASENAME>>.yml"
    - targets:              #
        - localhost:9100    # All this is a targets section in file_sd format
      labels:               #
        env: test           #
```
Such config will result in creating one file named `node.yml` in `{{ prometheus_config_dir }}/file_sd` directory.

Next this file needs to be loaded into scrape config. Here is modified version of our default `prometheus_scrape_configs`:
```yaml
prometheus_scrape_configs:
  - job_name: "prometheus"    # Custom scrape job, here using `static_config`
    metrics_path: "/metrics"
    static_configs:
      - targets:
          - "localhost:9090"
  - job_name: "example-node-file-servicediscovery"
    file_sd_configs:
      - files:
          - "{{ prometheus_config_dir }}/file_sd/node.yml" # This line loads file created from `prometheus_targets`
```

## Example

### Playbook

```yaml
---
- hosts: all
  roles:
  - prometheus
  vars:
    prometheus_targets:
      node:
      - targets:
        - localhost:9100
        labels:
          env: demosite
```

### Defining alerting rules files

Alerting rules are defined in `prometheus_alert_rules` variable. Format is almost identical to one defined in[ Prometheus 2.0 documentation](https://prometheus.io/docs/prometheus/latest/configuration/template_examples/).
Due to similarities in templating engines, every templates should be wrapped in `{% raw %}` and `{% endraw %}` statements. Example is provided in [defaults/main.yml](defaults/main.yml) file.

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

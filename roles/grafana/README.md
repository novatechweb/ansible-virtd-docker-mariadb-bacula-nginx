Ansible Role: Grafana
=========

Starts a Docker container for an instance of Grafana, an analytics and monitoring platform.

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
| `grafana_version` | should be set to _latest_ or to a tag defined on [Docker Hub](https://hub.docker.com/r/grafana/grafana/tags) |
| `grafana_container` | defines the name of the container to access it via the command line or its internal Docker network |
| `grafana_env` | provides variables into the container's environment. |
| `grafana_hostname` | hostname a container uses for itself. |
| `grafana_image` | defines the Docker image to instantiate. Override this to use a custom image i.e. different from the official one on Docker Hub. |
| `grafana_networks` | defines any Docker networks onto which this container should attach. Defaults to the Docker default bridge network. |
| `grafana_port_args` | defines any network ports that should be bound onto the host. |
| `grafana_restart_policy` | defines when Docker should restart this container. |

### Docker Volume Settings

| Name           | Description                        |
| -------------- | -----------------------------------|
| `grafana_etc_volume` | Host-side directory for Grafana configuration |
| `grafana_storage_volume` | Named volume for Grafana data storage |
| `grafana_volumes` | Container volume mount definitions |

### Grafana Application Configuration

Variables used to configure the Grafana application running within the container.

| Name           | Description                        |
| -------------- | -----------------------------------|
| `grafana_use_provisioning` | Use Grafana provisioning capability when possible (**grafana_version=latest will assume >= 5.0**). |
| `grafana_provisioning_synced` | Ensure no previously provisioned dashboards are kept if not referenced anymore. |
| `grafana_system_user` | Grafana server system user |
| `grafana_system_group` | Grafana server system group |
| `grafana_instance` | Grafana instance name |
| `grafana_logs_dir` | Path to logs directory |
| `grafana_data_dir` | Path to database directory |
| `grafana_url` | Full URL used to access Grafana from a web browser |
| `grafana_api_url` | URL used for API calls in provisioning if different from public URL. See [this issue](https://github.com/cloudalchemy/ansible-grafana/issues/70). |
| `grafana_domain`| setting is only used in as a part of the `root_url` option. Useful when using GitHub or Google OAuth |
| `grafana_server` | { protocol: http, enforce_domain: false, socket: "", cert_key: "", cert_file: "", enable_gzip: false, static_root_path: public, router_logging: false } | [server](http://docs.grafana.org/installation/configuration/#server) configuration section |
| `grafana_security`| [security](http://docs.grafana.org/installation/configuration/#security) configuration section |
| `grafana_database`| [database](http://docs.grafana.org/installation/configuration/#database) configuration section |
| `grafana_welcome_email_on_sign_up`| Send welcome email after signing up |
| `grafana_users`| [users](http://docs.grafana.org/installation/configuration/#users) configuration section |
| `grafana_auth`| [authorization](http://docs.grafana.org/installation/configuration/#auth) configuration section |
| `grafana_ldap`| [ldap](http://docs.grafana.org/installation/ldap/) configuration section. group_mappings are expanded, see defaults for example |
| `grafana_session`| [session](http://docs.grafana.org/installation/configuration/#session) management configuration section |
| `grafana_analytics`| Google [analytics](http://docs.grafana.org/installation/configuration/#analytics) configuration section |
| `grafana_smtp`| [smtp](http://docs.grafana.org/installation/configuration/#smtp) configuration section |
| `grafana_alerting`| [alerting](http://docs.grafana.org/installation/configuration/#alerting) configuration section |
| `grafana_log`| [log](http://docs.grafana.org/installation/configuration/#log) configuration section |
| `grafana_metrics`| [metrics](http://docs.grafana.org/installation/configuration/#metrics) configuration section |
| `grafana_tracing`| [tracing](http://docs.grafana.org/installation/configuration/#tracing) configuration section |
| `grafana_snapshots`| [snapshots](http://docs.grafana.org/installation/configuration/#snapshots) configuration section |
| `grafana_image_storage`| [image storage](http://docs.grafana.org/installation/configuration/#external-image-storage) configuration section |
| `grafana_dashboards`| List of dashboards which should be imported |
| `grafana_dashboards_dir` | "dashboards" | Path to a local directory containing dashboards files in `json` format |
| `grafana_datasources`| List of datasources which should be configured |
| `grafana_environment`| Optional Environment param for Grafana installation, useful ie for setting http_proxy |
| `grafana_plugins`|  List of Grafana plugins which should be installed |

## Examples

Datasource example:

```yaml
grafana_datasources:
  - name: prometheus
    type: prometheus
    access: proxy
    url: 'http://{{ prometheus_web_listen_address }}'
    basicAuth: false
```

Dashboard example:

```yaml
grafana_dashboards:
  - dashboard_id: 111
    revision_id: 1
    datasource: prometheus
```

Playbook example:

Fill in the admin password field with your choice, the Grafana web page won't ask to change it at the first login.

```yaml
- hosts: all
  roles:
    - role: grafana
      vars:
        grafana_security:
          admin_user: admin
          admin_password: enter_your_secure_password
```

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

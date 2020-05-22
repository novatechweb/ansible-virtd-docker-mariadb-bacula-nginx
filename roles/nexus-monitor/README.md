Ansible Role: Nexus Exporter
=========

Starts a Docker container for an instance of nexus-exporter, a utility to convert
metrics from Nexus Repository Manager into a form compatible with Prometheus.

Requirements
------------

This role assumes a host running the Docker engine.

To be effective, this container needs access to an instance of
Nexus Repository Manager.

Role Variables
--------------

Default variables are listed below.

### Docker Container Settings
These variables configure the container itself, like the version of the image
used or environment variables set inside.

| Name           | Description                        |
| -------------- | -----------------------------------|
| `nexus_monitor_image_name` | defines the Docker image to instantiate. |
| `nexus_monitor_container_name` | defines the name of the container to access it via the command line or its internal Docker network |

### Application Configuration

Variables used to configure the application running within the container.

| Name           | Description                        |
| -------------- | -----------------------------------|
| `nexus_monitor_host` | defines the Nexus Repository Manager instance from which to gather metrics |
| `nexus_monitor_user` | defines the user with permissions to access metrics on Nexus |
| `nexus_monitor_pass` | defines the password for `nexus_monitor_user` |

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

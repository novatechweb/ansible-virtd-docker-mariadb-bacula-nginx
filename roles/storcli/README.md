Ansible Role: StorCLI
=========

Installs StorCLI, a command line utility to manage a MegaRAID hardware
RAID controller.

Also installs storcli_exporter, a service to periodically convert RAID
controller status into Prometheus metrics.

Requirements
------------

This role assumes a CentOS host with a MegaRAID hardware RAID controller.

Role Variables
--------------

Default variables are listed below.

### StorCLI utility Settings
These variables configure the container itself, like the version of the image
used or environment variables set inside.

| Name           | Description                        |
| -------------- | -----------------------------------|
| `storcli_version` | defines version of storcli utility |
| `storcli_uri` | defines download uri of storcli archive |
| `storcli_checksum` | defines checksum of storcli archive |

### storcli_exporter settings

| Name           | Description                        |
| -------------- | -----------------------------------|
| `storcli_exporter_binary` | defines installation location of utility |
| `storcli_exporter_output` | defines output location of utility |

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

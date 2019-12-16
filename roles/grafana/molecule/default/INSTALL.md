# Vagrant driver installation guide

## Requirements

* Vagrant

  Vagrant is used to set up a consistent environment for testing.

* VirtualBox

  Virtual machines are used to test configuring and launching Docker containers.

## Install

### Vagrant

Follow the directions at Vagrant's [Getting Started](https://www.vagrantup.com/intro/getting-started/index.html) page to install Vagrant and prepare it for use.

### VirtualBox

Follow the directions at VirtualBox's [First Steps](https://www.virtualbox.org/manual/UserManual.html#Introduction) page to install VirtualBox and prepare it for use.

### molecule-vagrant

Install molecule's vagrant driver in the same Python environment as Molecule.

```sh
pip install molecule-vagrant
```

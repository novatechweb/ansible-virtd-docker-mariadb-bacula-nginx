
# Provisioning daedalus servers:
## SSH public keys
The public key for the user running the Ansible playbook needs to be in
`./public_keys`. The `bootstrap.yml` playbook installs all the public keys for
the ansibleremote user.


## Credentials
The `credentials` directory will be recreated if it dose not exist. This is the
desired result for a restore or a new bringup. If you wish to run the playbook
on an already existing install then these files are needed localy. The current
passwords would be found on the server in the `/etc/ansible-credentials/`
directory. Copy the entire directory structure from the remote server into your
local `./credentials/` folder. Make certain to change the permissions so the
files are readable localy.


## Recovery:
The machines (daedalus and testdaedalus) are loaded using a kickstart script.
These kickstart scripts need to be available to the CentOS installer. So far this
has been done by using another machine as a web server. Then next step is to
boot the CentOS CD and interrupt the Grub boot sequence. Then you add a new
kernel argument. Boot the CD with that argument and the machine will install
CentOS.

This is an example of the kernel argument added to run the kickstart script:
> ks=http://172.16.64.3/~georgem/ks-centos7-testdaedalus.cfg

Once the machine has been loaded the scripts in this git repository can be used.
Use the `bringup.sh` script to first set up the ansibleremote user and then setup
all the software.


## Provision:
Use the `provision.sh` script to run the Ansible playbooks against a daedalus
server. By default this script targets testdaedalus using an inventory file
named `staging`. To target the production servers, manually change
`provision.sh` to use the `production` inventory file. No script is provided as
provisioning production servers can be dangerous.


# Making Changes:
All roles and container sources are configured as subtrees of this repository.
Some scripts are provided in the `scripts/` directory to help manage all of the
roles and container subtrees.

When possible, make all commits to this repository. When reviewed and merged upstream
split and push the relevant subtrees to their own repositories using the provided
scripts.


## Scripts
Some scripts are provided to ease provisioning and managing changes to this repository.

- `./bringup.sh`

    Primarily a wrapper to the ansible role setup-remote-user, which configures the root
    and ansibleremote users and transfers all of the SSH public keys to the server.

- `./provision.sh`

    Runs `ansible-playbook` with the staging inventory and site.yml playbook.

- `scripts/subtree-config.sh`

    Used to manage the subtree configuration. Not strictly necessary for git subtrees,
    the `.gitsubtrees` file is used in this repository to track the numerous subtree
    repositories, branches and forks

- `scripts/subtree-import.sh`

    Import a subtree. Must have already been configured with `subtree-config.sh`.

- `scripts/subtree-push.sh`

    Split and push a subtree to a configured remote.

- `scripts/subtree-split.sh`

    Split a subtree to a branch.

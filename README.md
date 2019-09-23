[![Build Status](https://travis-ci.org/open-io/ansible-role-openio-conscience.svg?branch=master)](https://travis-ci.org/open-io/ansible-role-openio-conscience)
# Ansible role `conscience`

An Ansible role for conscience. Specifically, the responsibilities of this role are to:

- Install a namespace's conscience
- Configure a namespace's conscience

## Requirements

- Ansible 2.4+

## Role Variables


| Variable   | Default | Comments (type)  |
| :---       | :---    | :---             |
| `openio_conscience_bind_interface` | `"{{ ansible_default_ipv4.alias }}"` | Interface to use. |
| `openio_conscience_bind_address` | `"{{ hostvars[inventory_hostname]['ansible_' + openio_conscience_bind_interface]['ipv4']['address'] }}"` | Address IP to use |
| `openio_conscience_bind_port` | `6000` | Listening port |
| `openio_conscience_gridinit_dir` | `/etc/gridinit.d/{{ openio_conscience_namespace }}` | Path to copy the gridinit conf |
| `openio_conscience_gridinit_file_prefix` | `""` | Maybe set it to {{ openio_conscience_namespace }}- for old gridinit's style |
| `openio_conscience_data_security_custom` | `{}` | Dict of customized data security |
| `openio_conscience_multiple` | `{}` |  Dict of multiple consciences |
| `openio_conscience_namespace` | `"OPENIO"` | Namespace |
| `openio_conscience_persistence_period` | `30` | Time in second for score persistence |
| `openio_conscience_plugins` | `` | Conscience plugins |
| `openio_conscience_pools` | `[]` | Conscience pools |
| `openio_conscience_server` | `` | Conscience configuration |
| `openio_conscience_serviceid` | `"0"` | ID in gridinit |
| `openio_conscience_services` | `` | Dict of OpenIO services and its score formula |
| `openio_conscience_storage_policies_custom` | `{}` | Dict of customized storage policies |
| `openio_conscience_timeout_accepting_connection` | `1000` | Timeout for accepting connection |
| `openio_conscience_timeout_read_operations` | `1000` | Timeout for read connection |
| `openio_conscience_version` | `latest` | Install a specific version |
| `openio_conscience_provision_only` | `false` | Provision only, without restarting the services |
| `openio_conscience_package_upgrade` | `false` | Set the packages to the latest version (to be set in extra_vars) |

## Dependencies

No dependencies.

## Example Playbook

```yaml
- hosts: all
  gather_facts: true
  become: true
  vars:
    NS: OPENIO
  roles:
    - role: repository
    - role: users
    - role: namespace
      openio_namespace_name: "{{ NS }}"
    - role: gridinit
      openio_gridinit_namespace: "{{ NS }}"
    - role: meta
      openio_meta_namespace: "{{ NS }}"
    - role: conscienceagent
      openio_conscienceagent_namespace: "{{ NS }}"
    - role: oioproxy
      openio_oioproxy_namespace: "{{ NS }}"
    - role: conscience
      openio_conscience_namespace: "{{ NS }}"
      openio_conscience_pools:
        - name: rawx21
          targets:
            - slot: rawx-europe
              fallback: rawx
              count: 2
            - slot: rawx-asia
              fallback: rawx
              count: 1
          min_dist: 2

      openio_conscience_multiple:
        me: "{{ openio_conscience_bind_address }}:6600"
        group:
          - 172.17.0.3:6600
          - 172.17.0.4:6600

```


```ini
[all]
node1 ansible_host=192.168.1.173
```

## Contributing

Issues, feature requests, ideas are appreciated and can be posted in the Issues section.

Pull requests are also very welcome.
The best way to submit a PR is by first creating a fork of this Github project, then creating a topic branch for the suggested change and pushing that branch to your own fork.
Github can then easily create a PR based on that branch.

## License

GNU AFFERO GENERAL PUBLIC LICENSE, Version 3

## Contributors

- [Cedric DELGEHIER](https://github.com/cdelgehier) (maintainer)

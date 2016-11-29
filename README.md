# puppet-teleport

[![Build Status](https://travis-ci.org/jaxxstorm/puppet-teleport.svg?branch=master)](https://travis-ci.org/jaxxstorm/puppet-teleport)

#### Table of Contents

1. [Module Description - What the module does and why it is useful](#module-description)
2. [Setup - The basics of getting started with puppet-teleport](#setup)
    * [What puppet-teleport affects](#what-puppet-teleport-affects)
    * [Beginning with puppet-teleport](#beginning-with-puppet-teleport)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)


## Module description

This module will download, install and configure [Teleport](https://github.com/gravitational/teleport) a cluster SSH tool created by [Gravitational](https://gravitational.com).

For more information about Teleport, see the [documentation](http://gravitational.com/teleport/docs/quickstart/)

## Setup

### What puppet-teleport affects

puppet-teleport will:

  * Download the required golang binary from the teleport releases page and install it
  * Create a service/init script on your OS to start teleport
  * Configure the yaml config file and set up the required role

### Beginning with puppet-teleport

By default, puppet-teleport will configure teleport with a "node" role. Simple include the teleport module like so

```puppet
  include ::teleport
```

Teleport has multiple [roles](http://gravitational.com/teleport/docs/architecture/#high-level-overview) which are run from the same binary. In order to configure the use of these roles, you need to configure them in the yaml, and these can be done as parameters to the main teleport class. An example of this might be:


```puppet
  class { '::teleport':
    proxy_enable       => true,
    proxy_listen_addr  => '0.0.0.0',
  }
```

## Usage

### I just want to install teleport, what's the minimum I need?

```puppet
  include ::teleport
```

### I want to install all the teleport components, what do I need?

```puppet
  class { '::teleport':
    auth_enable  => true,
    proxy_enable => true,
  }
```

### I want to auth to another auth server, what do I need?

```puppet

  class { '::teleport':
    auth_servers => ['192.168.4.10', 192.168.4.11'],
  }
```

## Reference

### Classes

#### Public Classes
  * [`teleport`](#teleport): Installs and configured teleport in your environment

#### Private Classes
  * [`teleport::install`]: Downloads the teleport binary and installs it in your env 
  * [`teleport::config`]: Configure the service and the teleport config file
  * [`teleport::service`]: Manage the teleport service 
  

### `teleport`

#### Parameters

##### `version` [String]

Specifies the version of teleport to download

##### `archive_path` [String]

Where to download the teleport tarball

##### `extract_path` [String]

Directory to extract teleport

##### `bin_dir` [String]

Where to symlink teleport binaries

##### `assets_dir` [Bool]

Where to sylink the teleport web assets

##### `nodename` [String]

Teleport nodename. Default: `$::fqdn`

##### `data_dir` [String]

Teleport data directory.

##### `auth_token` [String]

The auth token to use when joining the cluster

##### `advertise_ip` [String]

When running in NAT'd environments, designates an IP for teleport to advertise.

##### `storage_backend` [String]

Which storage backend to use. 

##### `max_connections` [String]

Configure max connections for teleport

##### `max_users` [String]

Teleport max users

##### `log_dest` [String]

Log destination

##### `log_level` [String]

Log output level. Default: `"ERROR"`

#### `config_path` [String]

Path to config file for teleport. Default: `/etc/teleport.yaml`

#### `auth_servers` [Array]

An array of auth servers to connect to

#### `auth_enable` [Bool]

Whether to start the auth service. Default: `false`

#### `auth_listen_addr` [String]

Address to listen for auth_service

#### `auth_listen_port` [String]

Port to listen on for auth server

#### `auth_service_tokens` [Array]

The provisioning tokens for the auth tokens

#### `ssh_enable` [String]

Whether to start SSH service. Default: `true`

#### `ssh_listen_addr` [String]

Address to listen on for SSH connections. Default: `0.0.0.0`

#### `ssh_listen_port` [String]

Port to listen on for SSH connection

#### `labels` [Hash]

A hash of labels to assign to hosts

#### `proxy_enable` [Bool]

Where to start the proxy service. Default. `false`

#### `proxy_listen_addr` [String]

Address to listen on for proxy

#### `proxy_listen_port` [String]

Port to listen on for proxy connection

#### `proxy_web_listen_address` [String]

Port to listen on for web proxy connections

#### `proxy_ssl` [Bool]

Enable or disable SSL support. Default: `false`

#### `proxy_ssl_key` [String]

Path to SSL key for proxy

#### `proxy_ssl_cert` [String]

Path to SSL cert for proxy

#### `init_style` [String]

Which init system to use to start the service.

#### `manage_service` [Bool]

Whether puppet should manage and configure the service

#### `service_ensure` [String]

State of the teleport service (Running/Stopped)

#### `service_enable` [Bool]

Whether the service should be enabled on startup


## Limitations

Currently only works on Linux

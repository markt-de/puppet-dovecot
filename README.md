# puppet-dovecot

[![Build Status](https://github.com/markt-de/puppet-dovecot/actions/workflows/ci.yaml/badge.svg)](https://github.com/markt-de/puppet-dovecot/actions/workflows/ci.yaml)
[![Puppet Forge](https://img.shields.io/puppetforge/v/markt/dovecot.svg)](https://forge.puppetlabs.com/markt/dovecot)
[![Puppet Forge](https://img.shields.io/puppetforge/dt/markt/dovecot.svg)](https://forge.puppetlabs.com/markt/dovecot)

#### Table of Contents

1. [Description](#description)
1. [Usage](#usage)
    * [What this module affects](#what-this-module-affects)
    * [Configuration options](#configuration-options)
    * [External config files](#external-config-files)
    * [Poolmon configuration](#poolmon-configuration)
1. [Reference](#reference)
1. [Development](#development)
    - [Contributing](#contributing)

## Description

This module installs and manages the dovecot imap server and its plugins, and provides
resources and functions to configure the dovecot system.
It does, however, not configure any of those systems beyond the upstream defaults.

This module is intended to work with Puppet 5 and 6, tested dovceot and OS versions are
listed below. Patches to support other setups are welcome.

## Usage

### What this module affects

By default, this module...

* installs the dovecot package
* recursively purges all dovecot config files

### Configuration options

While on a puppet-managed host, splitting the config into multiple conf.d files provides
not much advantage, this module supports managing both the dovecot.conf file and several
conf.d files.

The dovecot class takes two parameters, $config for dovecot.conf entries and $configs for
conf.d file entries:

```puppet
class { 'dovecot':
  plugins => ['imap', 'lmtp'],
  config => {
    protocols => 'imap lmtp',
    listen    => '*, ::',
  },
  configs => {
    '10-auth' => {
      passdb => {
        driver => 'passwd-file',
        args   => 'username_format=%u /etc/dovecot/virtual_accounts_passwd',
      },
    },
    '10-logging' => {
      log_path => 'syslog',
    },
  }
}
```

This can be conveniently used from hiera:

```yaml
dovecot::plugins:
  - imap
  - lmtp
  - sieve
dovecot::config:
  protocols: imap sieve lmtp
  hostname: "%{::fqdn}"
dovecot::configs:
  '10-auth':
    disable_plaintext_auth: yes
    passdb:
      driver: passwd-file
      args: scheme=CRYPT username_format=%u /etc/dovecot/virtual_accounts_passwd
  '10-master':
    default_process_limit: 200
    default_client_limit: 2000
    service lmtp:
      unix_listener /var/spool/postfix/private/dovecot-lmtp:
        user: postfix
        group: postfix
        mode: '0600'
  '10-ssl':
    ssl: yes
    ssl_cert: '</etc/dovecot/ssl/dovecot.crt'
    ssl_key: '</etc/dovecot/ssl/dovecot.key'
```

For advanced use-cases you can also use the provided `dovecot::create_config_resources` and
`dovecot::create_config_file_resources` functions, that are used to handle the $config and
$configs parameters.

If you want to use the dovecot::config resource directly, the easiest way is to put both the
file (optional) and the hierachical config key into the resource title:

```puppet
dovecot::config {
  'protocols': value => 'imap lmtp';
  'listen':
     value => '*, ::',
     comment => 'Listen on all interfaces',
  ;
  '10-auth:passdb.driver': value => 'passwd-file';
  '10-auth:passdb.args': value => 'username_format=%u /etc/dovecot/virtual_accounts_passwd'
}
```

But you can also specify them separately:

```puppet
dovecot::config { 'dovecot passdb driver':
  file     => '10-auth',
  sections => ['passdb'],
  key      => 'driver',
  value    => 'passwd-file',
}
```

By default all regular config files are created with mode 0644, but this can be changed by
creating the `dovecot::configfile` instance manually and specifying the `$mode` param, or
by setting the global `dovecot::configs_mode` parameter/hiera key.

### External config files

In some cases, dovecot requires an external config file to be passed as a config value. This
is especially the case for SQL- and LDAP-based userdbs.

These external config files are using a similar syntax, but are parsed by a different parser
(and at a different point of time), as [explained in the Dovecot wiki](https://wiki.dovecot.org/ConfigFile#External_config_files).

This module supports such external config files using the `dovecot::extconfigfile` type, or
the `dovecot::extconfigs` parameter/hiera key:

```yaml
dovecot::configs:
  '10-auth':
    passdb:
      driver: sql
      args: /etc/dovecot/dovecot-sql.conf.ext
dovecot::extconfigs:
  'dovecot-sql.conf.ext':
     driver: pgsql
     connect: host=sql.example.com dbname=virtual user=virtual password=blarg
     default_pass_scheme: SHA256-CRYPT
     password_query: "SELECT email as user, password FROM virtual_users WHERE email='%u';"
```

Since external config files often contain sensitive information like database passwords, they
are set to mode 0600 by default. This can be changed using the type's `$mode` parameter, or
the global `dovecot::extconfigs_mode` parameter/hiera key.

If you need to specify additional content in the file, like dict maps, you can use the 
extended notation that takes an `entries` and an `additional_content` key:

```yaml
dovecot::extconfigs:
  'dovecot-dict-sql.conf.ext':
    entries:
      connect: host=localhost dbname=mails user=sqluser password=sqlpass
    additional_content: |+
      map {
        pattern = shared/shared-boxes/user/$to/$from
        table = user_shares
        value_field = dummy

        fields {
          from_user = $from
          to_user = $to
        }
      }
```

*NOTE*: These external config files are usually stored in `/etc/dovecot`. Unfortunately,
the example-config delivered with Dovecot also contains `.conf.ext` files in `conf.d/`, which
are !included from `10-auth.conf`. Please note that these are *not* external config files as
explained here, they are included and parsed by the normal config parser. The example config
splits them out to provide multiple options the user can easily choose one from. In a
puppet-based setup, this should not be necessary, and is thus currently not supported by this
module. Please provide a valid use-case as a bug report, if you have one.

### Poolmon configuration

For multi-server setups it is possible to enable built-in support for Poolmon:

```yaml
dovecot::poolmon_manage: true
dovecot::poolmon_version: '0.6'

dovecot::poolmon_config:
  scan_interval: 30
  check_timeout: 5
  log_debug: false
  logfile: 'syslog'
  check_port:
    - 110
    - 143
  check_ssl:
    - 993
  socket: '/var/run/dovecot/director-admin'
  lockfile: '/var/run/poolmon.pid'
```

*NOTE*: `$dovecot::poolmon_config` uses "hash" merge behavior during lookup
(see [Merge behavior](#merge-behavior) below).

## Reference

Classes and parameters are documented in [REFERENCE.md](REFERENCE.md).

### Merge behavior

Although this module defaults to "deep" merge behavior for lookups, there's one notable exception.
The poolmon configuration `$dovecot::poolmon_config` utilizes the "hash" merge behavior. This way
it is possible to replace default values when necessary, i.e. the `check_port` item.

## Development

### Contributing

Please use the GitHub issues functionality to report any bugs or requests for new features. Feel free to fork and submit pull requests for potential contributions.

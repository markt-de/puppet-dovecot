# Class: dovecot
# ===========================
#
# This class allows simple configuration of the dovecot imap server.
#
# There is no semantic abstraction done in this class, all config
# parameters are passed directly to dovecot via config files.
#
# Parameters
# ----------
# * `config`
# A hash with two keys:
#   - `entries`
#     a hash of dovecot config file entries
#   - `includes`
#     an array of files to be included
#
# * `extra_configs`
# Hash of named extra config files, which are included in the main config by
# default (see `extra_configs_include`). 
# The files are put in conf.d/${name}.conf
#
# * `extra_configs_include`
# Whether extra configs should be automatically included from the main config.
#
# * `purge_unmanaged` 
# Whether to purge all unmanaged files in the dovecot directory (default true)
#
# Examples
# --------
#
# @example
#    # Using a profile to load merged values from hiera:
#    
#    $config = hiera_hash("${title}::config", undef)
#    $extra_configs = hiera_hash("${title}::extra_configs", undef)
#    $plugins = hiera_array("${title}::plugins", undef)
#    class { 'dovecot':
#      config => $config,
#      extra_configs => $extra_configs,
#      plugins => $plugins,
#    }
#
# === Authors
#
# Bernhard Frauendienst <puppet@nospam.obeliks.de>
#
# === Copyright
#
# Copyright 2017 Bernhard Frauendienst, unless otherwise noted.
#
class dovecot(
    Optional[Dovecot::Config] $config = undef,
    Optional[Dovecot::ExtraConfigs] $extra_configs = undef,
    Boolean $extra_configs_include = true,
    String $config_path = '/etc/dovecot',
    Array[String[1]] $plugins = [],
    Boolean $packages_install = true,
    Boolean $service_manage = true,
    Boolean $purge_unmanaged = true,
) {

  if ($packages_install) {
    package { 'dovecot':
      ensure => 'present',
      name   => dovecot::package_name('core'),
    }
    $plugins.each |$plugin| {
      package { "dovecot-${plugin}":
        ensure => 'present',
        name   => dovecot::package_name($plugin),
      }
    }
  }

  if ($service_manage) {
    service { 'dovecot':
      ensure  => 'running',
      enable  => true,
      require => Package['dovecot'],
    }
  }

  if ($purge_unmanaged) {
    file { "purge unmanaged files":
      path => $config_path,
      ensure => 'directory',
      recurse => 'true',
      purge => 'true',
    }
  }

  $main_config = $config ? {
    Undef   => {
      entries => {},
      includes => [],
    },
    default => $config,
  }

  if ($extra_configs_include and $extra_configs != undef) {
    $main_explicit_includes = $main_config['includes'] ? {
      Undef => [],
      default => $main_config['includes'],
    } 
    $main_extra_includes = sort(keys($extra_configs)).map |$basename| {
      "conf.d/${basename}.conf"
    }
    $main_includes = $main_explicit_includes + $main_extra_includes
  } else {
    $main_includes = $main_config['includes']
  }
  dovecot::configfile { "main config":
    relpath => "dovecot.conf",
    entries => $main_config['entries'],
    includes => $main_includes,
  }

  # all other configs can simply be handled by configfile resources
  if ($extra_configs != undef) {
    $extra_configs.each |$name, $extra_config| {
      dovecot::configfile { $name:
        entries  => $extra_config['entries'],
        includes => $extra_config['includes'],
      }
    }
  }
}

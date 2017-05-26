# @summary This class allows simple configuration of the dovecot imap server.
#
#   There is no semantic abstraction done in this class, all config
#   parameters are passed directly to dovecot via config files.
#
# @param config_path the path to the dovecot config dir
# @param plugins the list of plugins to install
# @param packages_install whether to install the dovecot core and plugin packages
# @param service_manage whether to manage the dovecot service
# @param purge_unmanaged whether to purge all unmanaged files in the dovecot directory
#
# @example Using a profile to load merged values from hiera:
#    
#    $config = hiera_hash("${title}::config", {})
#    $extra_configs = hiera_hash("${title}::extra_configs", {})
#    $plugins = hiera_array("${title}::plugins", undef)
#    class { 'dovecot':
#      plugins => $plugins,
#    }
#    dovecot::create_config_resources($config)
#    dovecot::create_config_file_resources($extra_configs)
#
# @author Bernhard Frauendienst <puppet@nospam.obeliks.de>
#
class dovecot(
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
}

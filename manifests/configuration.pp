# @api private 
# This class handles dovecot configuration. Avoid modifying private classes.
class dovecot::configuration inherits dovecot {
  if ($dovecot::purge_unmanaged) {
    file { 'purge unmanaged files':
      ensure  => 'directory',
      path    => $dovecot::config_path,
      recurse => true,
      purge   => true,
    } ->
    # always keep conf.d
    file { "${dovecot::config_path}/conf.d":
      ensure => 'directory',
    }
  }

  dovecot::create_config_resources($dovecot::config)
  dovecot::create_config_file_resources($dovecot::configs)
}

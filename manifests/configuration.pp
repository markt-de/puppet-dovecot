# @api private 
# This class handles dovecot configuration. Avoid modifying private classes.
class dovecot::configuration inherits dovecot {
  if ($dovecot::purge_unmanaged) {
    file { 'purge unmanaged files':
      ensure  => 'directory',
      path    => $dovecot::config_path,
      recurse => true,
      purge   => true,
      before  => File["${dovecot::config_path}/conf.d"]
    }
  }

  # always keep/create conf.d
  file { "${dovecot::config_path}/conf.d":
    ensure => 'directory',
  }

  if ($dovecot::directory_private_manage) {
    # "private" directory is part of many distros, if requested (true by
    # default) manage it to keep log noise low on package updates
    file { "${dovecot::config_path}/private":
      ensure => 'directory',
    }
  }

  dovecot::create_config_resources($dovecot::config)
  dovecot::create_config_file_resources($dovecot::configs)
  $dovecot::extconfigs.each|$key, $value| {
    dovecot::extconfigfile { $key:
      entries => $value,
      relpath => $key,
    }
  }
}

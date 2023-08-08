# @summary Installs and configures Poolmon.
# @api private 
class dovecot::poolmon inherits dovecot {
  if ($dovecot::poolmon_manage) {
    $dirname = "poolmon-${dovecot::poolmon_version}"
    $filename = "${dirname}.tar.gz"
    $install_path = "${dovecot::poolmon_basepath}/${dirname}"

    file { $install_path:
      ensure => directory,
      mode   => '0775',
    }

    # merge default config with user-defined values
    $_archive_params = {
      path          => "/tmp/${filename}",
      source        => "https://github.com/brandond/poolmon/archive/${dovecot::poolmon_version}.tar.gz",
      extract_path  => $dovecot::poolmon_basepath,
      creates       => "${install_path}/poolmon",
      require       => File[$install_path],
    }
    $archive_params = deep_merge($_archive_params, $dovecot::poolmon_archive_params)

    # download poolmon
    archive { $filename:
      * => $archive_params,
    }

    file { $dovecot::poolmon_exec:
      ensure  => link,
      target  => "${install_path}/poolmon",
      require => Archive[$filename],
    }

    # optional file containing credentials for dovecot director
    if ($dovecot::poolmon_config['username'] =~ String) and
    ($dovecot::poolmon_config['password'] =~ String) {
      $poolmon_credfile = "${dovecot::poolmon_config_file}.cred"
      $_template = '<%= $username %><%= "\n" %><%= $password %>'
      file { $poolmon_credfile:
        mode    => '0600',
        content => inline_epp($_template, {
            username => $dovecot::poolmon_config['username'],
            password => $dovecot::poolmon_config['password']
        }),
        before  => [
          File[$dovecot::poolmon_config_file],
          Service['poolmon'],
        ],
      }
    } else {
      $poolmon_credfile = undef
    }

    # create service configuration file
    file { $dovecot::poolmon_config_file:
      mode    => '0600',
      content => epp('dovecot/poolmon.config', {
          logfile       => $dovecot::poolmon_config['logfile'],
          lockfile      => $dovecot::poolmon_config['lockfile'],
          socket        => $dovecot::poolmon_config['socket'],
          log_debug     => $dovecot::poolmon_config['log_debug'],
          scan_interval => $dovecot::poolmon_config['scan_interval'],
          check_timeout => $dovecot::poolmon_config['check_timeout'],
          lmtp_from     => $dovecot::poolmon_config['lmtp_from'],
          lmtp_to       => $dovecot::poolmon_config['lmtp_to'],
          username      => $dovecot::poolmon_config['username'],
          password      => $dovecot::poolmon_config['password'],
          check_port    => $dovecot::poolmon_config['check_port'],
          check_ssl     => $dovecot::poolmon_config['check_ssl'],
          credfile      => $poolmon_credfile,
          provider      => $dovecot::poolmon_service_provider,
          enable        => $dovecot::poolmon_service_enable,
      }),
    }

    # install service script
    file { $dovecot::poolmon_service_file:
      mode    => $dovecot::poolmon_service_mode,
      content => epp("dovecot/poolmon.service.${dovecot::poolmon_service_provider}"),
    }

    # enable/start service
    service { 'poolmon':
      ensure    => $dovecot::poolmon_service_ensure,
      enable    => $dovecot::poolmon_service_enable,
      subscribe => [
        Archive[$filename],
        File[$dovecot::poolmon_config_file],
        File[$dovecot::poolmon_service_file],
      ],
    }
  }
}

# @summary This class allows simple configuration of the dovecot imap server.
#
#   There is no semantic abstraction done in this class, all config
#   parameters are passed directly to dovecot via config files.
#
# @param config a hash of config file entries, with nested hashes parsed as sections
# @param config_path the path to the dovecot config dir
# @param configs a hash of conf.d file names to $config-style hashes
# @param package_ensure [String] Whether to install the dovecot package, and what version to install.
#   Values: 'present', 'latest', or a specific version number. Default value: 'present'.
# @param package_manage whether to install the dovecot core and plugin packages
# @param plugin contains a package_name parameter for each plugin (if available)
# @param plugins the list of plugins to install
# @param poolmon_manage [Boolean] Whether to manage the poolmon service. Default value: false.
# @param purge_unmanaged whether to purge all unmanaged files in the dovecot directory
# @param service_enable [Boolean] Whether to enable the dovecot service at boot. Default value: true.
# @param service_ensure [Enum['running', 'stopped']] Whether the dovecot service should be running. Default value: 'running'.
# @param service_manage whether to manage the dovecot service
# @param service_name [String] The dovecot service to manage. Default value: varies by operating system.
#
# @example Using a profile to load merged values from hiera:
#    
#    $config = hiera_hash("${title}::config", {})
#    $configs = hiera_hash("${title}::configs", {})
#    $plugins = hiera_array("${title}::plugins", undef)
#    class { 'dovecot':
#      plugins => $plugins,
#      config => $config,
#      configs => $configs,
#    }
#
# @author Bernhard Frauendienst <puppet@nospam.obeliks.de>
#
class dovecot(
  Hash $config,
  String $config_path,
  Hash $configs,
  String $configs_mode,
  Hash $extconfigs,
  String $extconfigs_mode,
  String $package_ensure,
  Boolean $package_manage,
  Array[String] $package_name,
  Hash $poolmon_archive_params,
  String $poolmon_basepath,
  Hash $poolmon_config,
  String $poolmon_config_file,
  String $poolmon_exec,
  Boolean $poolmon_manage,
  Boolean $poolmon_service_enable,
  Enum['running', 'stopped'] $poolmon_service_ensure,
  String $poolmon_service_file,
  String $poolmon_service_mode,
  Enum['init', 'rc', 'systemd'] $poolmon_service_provider,
  String $poolmon_version,
  Boolean $purge_unmanaged,
  Boolean $directory_private_manage,
  Hash $plugin,
  Array[String[1]] $plugins,
  Boolean $service_enable,
  Enum['running', 'stopped'] $service_ensure,
  Boolean $service_manage,
  String $service_name,
) {
  contain dovecot::install
  contain dovecot::configuration
  contain dovecot::service
  contain dovecot::poolmon

  Class['::dovecot::install']
  -> Class['::dovecot::configuration']
  ~> Class['::dovecot::service']
  ~> Class['::dovecot::poolmon']
}

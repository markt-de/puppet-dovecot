# Function: dovecot::create_config_file_resources()
# =============
#
# @summary create {dovecot::config} resources from a nested hash (e.g. from hiera)
# 
# Create {dovecot::config} resources from a nested hash, suitable for
# conveniently loading values from hiera.
#
# The first level of keys is the config files to be written to, the
# values being the hierarchical values that will be passed to 
# the {dovecot::create_config_resources} function
# 
# @param configfile_hash a hash of config file names mapped to config hashes
# @param include_in_main_config whether the single config files should be included from dovecot.conf
# @param params          a hash of params passed to the {dovecot::config} resource (:file will be overridden)
#
# @see dovecot::create_config_resources
# @see dovecot::config
#
# @author Bernhard Frauendienst <puppet@nospam.obeliks.de>
#
function dovecot::create_config_file_resources(
  Hash[String, Hash] $configfile_hash,
  Boolean $include_in_main_config = true,
  Hash $params = {}
) {
  $configfile_hash.each |$key, $value| {
    $file_params = {
      file => $key
    } + $params
    dovecot::create_config_resources($value, $file_params)
    dovecot::config { "dovecot.conf !include ${key} ${value}":
      key   => '!include',
      value => "conf.d/${key}.conf",
    }
  }
}

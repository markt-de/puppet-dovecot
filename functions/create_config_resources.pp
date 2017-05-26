# Function: dovecot::create_config_resources()
# ==================
#
# @summary create dovecot::config resources from a nested hash (e.g. from hiera)
#
# Create dovecot::config resources from a nested hash, suitable for
# conveniently loading values from hiera.
# The key-value pairs from the hash represent config keys and values
# passed to dovecot::config for simple values, Hash values recursively
# create nested sections, and Array values are joined with spaces.
# 
# @param config_hash a hash of (non-hierarchical) key names mapped to values
# @param params      a hash of params passed to dovecot::config (must not include :sections, :key, or :value)
# @param sections    the section names of the hierarchical key, will usually only be specified 
#   on recursive calls from within this function itself
#
# @see dovecot::create_config_file_resources
# @see dovecot::config
#
# @author Bernhard Frauendienst <puppet@nospam.obeliks.de>
#
function dovecot::create_config_resources(Hash[String, NotUndef] $config_hash, Hash $params={}, Array[String] $sections=[]) {
  $config_hash.each |$key, $value| {
    case $value {
      Hash: {
        dovecot::create_config_resources($value, $params, $sections + $key)
      }
      Array: {
        # be lazy and delegate to ourself. Non-string values will be stringified without mercy!
        dovecot::create_config_resources({$key => join($value, ' ')}, $params, $sections)
      }
      default: {
        dovecot::config { "${params[file]}:${join($sections + $key, '.')}":
          sections => $sections,
          key      => $key,
          value    => $value,
          * => $params
        }
      }
    }
  }
}

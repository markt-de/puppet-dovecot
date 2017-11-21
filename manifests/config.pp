# dovecot::config
# ===========================
#
# @summary this type manages a single config entry
# 
# Dovecot uses its own config format. This format basically allows to define a 
# hierarchy of configuration sections (and syntactically identical filters, so
# they will just be treated as sections by this module).
#
# Since in puppet, we want to map each single config entry as its own resource,
# the hierarchy has been "flattened" to hierarchical keys.
#
# A key/value pair `foo = bar` nested in a `section` object, would look like 
# this in a dovecot config file:
#
# ```json
# section {
#   foo = bar
# }
# ```
#
# To reference this key in a dovecot::config variable, you would use the 
# notation `section.foo`.
#
# Title/Name format
# ------------
# 
# This module can manage both a global dovecot.conf and single conf.d files. The
# module author recommends single file setups for puppet-managed hosts, but users
# can choose to split their managed config into single files.
#
# To specify which file a config entry should got to, you can use the `file` 
# parameter.
#
# For convenience reasons, however, this resource also allows to encode the values 
# for $sections, $key, and $file into the resource's name (which is usally the same as 
# its title).
#
# If the $name of the resource matches the format "[<file>:][<sections>.]<name>", and 
# all of $file, $sections, and $key have not been specified, the values from the name 
# are used.
# This simplifies creating unique resources for identical settings in different 
# files.
#
# @param sections
#   An array of section names that define the hierarchical name of this key.
#   E.g. `["protocol imap", "plugin"] to denote the `protocol imap { plugin {` section.
#
# @param key
#   The key name of the config setting. The key is expected as a single non-hierachical 
#   name without any sections/filters.
#   The special values `!include` and `!include_try` can be used for includes.
#
# @param file
#   The file to put the value in. If undef (the default), the value is put into the 
#   global dovecot.conf, otherwise the value si written to conf.d/${file}.conf
#   The value of this parameter must not include any path information or file extension.
#   E.g. `10-auth`
# 
# @param value
#   the value of this config entry.
#
# @param comment
#   an optional comment that will be written to the config file above the entry
#
# @param ensure
#   whether this entry should be `present` or `absent`. Usually not needed at all,
#   because the config file will be fully managed by puppet and re-created each time.
#
# @author Bernhard Frauendienst <puppet@nospam.obeliks.de>
#
define dovecot::config (
  $value,
  Optional[String] $comment = undef,
  Enum['present', 'absent'] $ensure = 'present',
  Optional[String] $file = undef,
  Optional[String] $key = undef,
  Optional[Array[String]] $sections = undef,
) {
  if (!$key and !$sections and !$file and $name =~ /\A(?:([^:]+):)?(.+\.)?([^.]+)\z/) {
    $configfile = $1
    $configsections = $2 ? {
      Undef => [],
      default => split($2, '\.'),
    }
    $configkey = $3
  } else {
    $configfile = $file
    $configsections = pick($sections, [])
    $configkey = pick($key, $name)
  }

  $full_file = $configfile ? {
    Undef   => "${dovecot::config_path}/dovecot.conf",
    default => "${dovecot::config_path}/conf.d/${configfile}.conf"
  }

  $_full_key = join($configsections + $configkey, '/')
  $full_key = $key ? {
    /\A!/   => "${_full_key} ${value}",
    default => $_full_key,
  }
  dovecot::configentry { "dovecot config ${full_file} ${full_key}":
    ensure   => $ensure,
    file     => $full_file,
    sections => $configsections,
    key      => $configkey,
    value    => $value,
    comment  => $comment,
    notify   => Class['dovecot::service'],
  }
}


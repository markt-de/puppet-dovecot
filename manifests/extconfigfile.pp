# dovecot::extconfigfile
# ===========================
#
# @summary resource for external config files providing a very basic
# 	   key-value interface
# @param entries a hash of string=string entries. All values will be
#                written as-is to the file, any escaping must already
#                be applied.
# @param relpath the path of the external config file relative to
#                dovecot::config_path, including the desired extension.
#                Defaults to the resource title.
# @param warn whether to prepend the default warning (if `true`), a
#             custom warning (if a `String`), or nothing at all.
#
#
# @author Bernhard Frauendienst <puppet@nospam.obeliks.de>
#
define dovecot::extconfigfile(
  Hash[String, String] $entries,
  Optional[String] $additional_content = undef,
  String $relpath = $title,
  Variant[Boolean, String] $warn = true,
  $group = 0,
  $mode = $dovecot::extconfigs_mode,
  $owner = 'root',
) {
  $_header = $warn ? {
    true    => "# This file is managed by Puppet. DO NOT EDIT.\n\n",
    String  => "${warn}\n",
    default => '',
  }

  $_entries = String($entries, { Hash => {
    format => '% h',
    separator => "\n",
    separator2 => ' = ',
    string_formats => { Any => '%s' },
  }})

  if $additional_content {
    $_additional_content = "${additional_content}\n"
  } else {
    $_additional_content = ''
  }

  $_content = "${_header}${_entries}\n${additional_content}"

  file { "dovecot external config file ${title}":
    path    => "${dovecot::config_path}/${relpath}",
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => $_content,
    require => Class['dovecot::install'],
    notify  => Class['dovecot::service'],
  }

}


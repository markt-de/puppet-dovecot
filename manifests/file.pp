# @summary Simple file resource that notifies the dovecot service.
#
# @param content
#   The content of the file.
#
# @param group
#   The group that should own the file.
#
# @param mode
#   The permissions for the file.
#
# @param owner
#   The user that should own the file.
#
# @param path
#   The target path for the file.
#
# @author Bernhard Frauendienst <puppet@nospam.obeliks.de>
#
define dovecot::file (
  String $content,
  Stdlib::Absolutepath $path,
  Variant[Integer, String] $group = 0,
  Variant[Integer, String] $mode = '0644',
  Variant[Integer, String] $owner = 'root',
) {
  file { "dovecot file ${title}":
    path    => $path,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => $content,
    require => Class['dovecot::install'],
    notify  => Class['dovecot::service'],
  }
}

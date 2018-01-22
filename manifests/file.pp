# dovecot::file
# ===========================
#
# @summary simple file resource that notifies the dovecot service.
#
# @author Bernhard Frauendienst <puppet@nospam.obeliks.de>
#
define dovecot::file(
  $content,
  $path,
  $group = 0,
  $mode = '0644',
  $owner = 'root',
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

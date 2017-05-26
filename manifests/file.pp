# dovecot::file
# ===========================
#
# @summary simple file resource that notifies the dovecot service.
#
# @author Bernhard Frauendienst <puppet@nospam.obeliks.de>
#
define dovecot::file(
  $path,
  $owner = 'root',
  $group = 'root',
  $mode = '0644',
  $content,
) {

  file { "dovecot file ${title}":
    path    => $path,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => $content,
    require => Package['dovecot'],
    notify  => Service['dovecot'],
  }
    
}

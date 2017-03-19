# Class: dovecot::file
# ===========================
#
# Simple file resource that notifies the dovecot service.
#
# === Authors
#
# Bernhard Frauendienst <puppet@nospam.obeliks.de>
#
# === Copyright
#
# Copyright 2017 Bernhard Frauendienst, unless otherwise noted.
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

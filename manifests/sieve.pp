# dovecot::sievec
# ===========================
#
# @summary simple sieve script resource that gets compiled by sievec and
#   notifies the dovecot service.
#
# @author Bernhard Frauendienst <puppet@nospam.obeliks.de>
#
define dovecot::sieve(
  $path  = $name,
  $owner = 'root',
  $group = 'root',
  $mode  = '0644',
  $content = undef,
  $source  = undef,
) {

  file { "dovecot sieve ${title}":
    path    => $path,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => $content,
    source  => $source,
    require => Package['dovecot-sieve'],
  } 
  ~> exec { "compile sieve ${title}":
    command     => "/usr/bin/sievec ${path}",
    user        => $owner,
    group       => $group,
    refreshonly => true,
    notify      => Service['dovecot'],
  }
}

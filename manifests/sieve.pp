# dovecot::sievec
# ===========================
#
# @summary simple sieve script resource that gets compiled by sievec and
#   notifies the dovecot service.
#
# @author Bernhard Frauendienst <puppet@nospam.obeliks.de>
#
define dovecot::sieve(
  $content = undef,
  $group = 0,
  $mode = '0644',
  $owner = 'root',
  $path = $name,
  Stdlib::Absolutepath $sievec = lookup('dovecot::sieve::sievec'),
  $source = undef,
) {

  file { "dovecot sieve ${title}":
    path    => $path,
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => $content,
    source  => $source,
    require => Class['dovecot::install'],
  }
  ~> exec { "compile sieve ${title}":
    command     => "${sievec} ${path}",
    user        => $owner,
    group       => $group,
    refreshonly => true,
    notify      => Class['dovecot::service'],
  }
}

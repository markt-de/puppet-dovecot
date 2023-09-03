# @summary Simple sieve script resource that gets compiled by sievec and
# notifies the dovecot service.
#
# @param content
#   The desired content of the file, as string. This attribute is mutually exclusive with `source`.
#
# @param source
#   A source file, which will be copied into place on the local system. This attribute is mutually exclusive with `content`.
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
# @param sievec
#   The path to the sievec binary.
#
# @author Bernhard Frauendienst <puppet@nospam.obeliks.de>
#
define dovecot::sieve (
  Optional[String] $content = undef,
  Optional[String] $source = undef,
  Variant[Integer, String] $group = 0,
  Variant[Integer, String] $mode = '0644',
  Variant[Integer, String] $owner = 'root',
  Stdlib::Absolutepath $path = $name,
  Stdlib::Absolutepath $sievec = $dovecot::sievec,
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

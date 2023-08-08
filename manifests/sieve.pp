# @summary Simple sieve script resource that gets compiled by sievec and
# notifies the dovecot service.
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
# @param sievec
#   The path to the sievec binary.
#
# @param source
#   Optional source for the file resource to use instead of `$content`.
#
# @author Bernhard Frauendienst <puppet@nospam.obeliks.de>
#
define dovecot::sieve (
  String $content = undef,
  Variant[Integer, String] $group = 0,
  Variant[Integer, String] $mode = '0644',
  Variant[Integer, String] $owner = 'root',
  Stdlib::Absolutepath $path = $name,
  Stdlib::Absolutepath $sievec = $dovecot::sievec,
  Optional[String] $source = undef,
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

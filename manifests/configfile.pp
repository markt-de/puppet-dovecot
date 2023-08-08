# @summary Manages a single dovecot config file
#
# @note This define is only for internal use, use dovecot::config instead.
#
# @param comment
#   An optional comment to be printed at the top of the file instead of
#   the default warning.
#
# @param ensure
#   Whether the file should be `present` or `absent`.
#
# @param file
#   The file to put the entry in.
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
# @see dovecot::config
#
# @author Bernhard Frauendienst <puppet@nospam.obeliks.de>
#
define dovecot::configfile (
  Stdlib::Absolutepath $file = $title,
  Optional[String] $comment = undef,
  Enum['present', 'absent'] $ensure = 'present',
  Variant[Integer, String] $owner = 'root',
  Variant[Integer, String] $group = 0,
  Variant[Integer, String] $mode = $dovecot::configs_mode,
) {
  concat { $file:
    owner  => $owner,
    group  => $group,
    mode   => $mode,
    warn   => !$comment,
    order  => 'alpha',
    notify => Class['dovecot::service'],
  }

  if ($comment) {
    concat::fragment { "dovecot ${file} config 01 file warning comment":
      target  => $file,
      content => join(suffix(prefix(split($comment, '\n'), '# '), '\n')),
    }
  }
}

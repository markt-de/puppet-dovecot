# dovecot::configfile
# ===========================
#
# @summary manages a single dovecot config file
#
# @note This class is only for internal use, use dovecot::config instead.
#
# @param file  the file to put the entry in
# @param comment an optional comment to be printed at the top of the file instead of
#   the default warning
# @param ensure whether the file should be `present` or `absent`
#
# @see dovecot::config
#
# @author Bernhard Frauendienst <puppet@nospam.obeliks.de>
#
define dovecot::configfile (
  Stdlib::Absolutepath $file = $title,
  Optional[String] $comment = undef,
  Enum['present', 'absent'] $ensure = 'present',
) {
  concat { $file:
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
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

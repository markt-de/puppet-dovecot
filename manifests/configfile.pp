# Class: dovecot::configfile
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
define dovecot::configfile(
  String[1] $relpath = "conf.d/${title}.conf",
  Dovecot::ConfigEntries $entries,
  Dovecot::ConfigIncludes $includes = [],
) {
  include dovecot

  dovecot::file { $title:
    path    => "${::dovecot::config_path}/${relpath}",
    content => epp("dovecot/configfile", { entries => $entries, includes => $includes })
  }
}

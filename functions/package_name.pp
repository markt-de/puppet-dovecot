# == Function: dovecot::package_name()
#
# A type for sections and subsections inside dovecot config
# files, also used for filters (which have identical syntax).
#
# Each entry in the hash is a single section, they key being
# the name of the section (e.g. 'imap' in protocol imap {}),
# the value again a number of config entries.
# The empty key can be used for unnamed sections.
#
# === Authors
#
# Bernhard Frauendienst <puppet@nospam.obeliks.de>
#
# === Copyright
#
# Copyright 2017 Bernhard Frauendienst, unless otherwise noted.
#
# === License
#
# 2-clause BSD license
#
function dovecot::package_name(String[1] $pluginName) {
  $::osfamily ? {
    'Debian' => "dovecot-${pluginName}",
    default  => fail("OS family ${::osfamily} not yet supported by module dovecot")
  } 
}

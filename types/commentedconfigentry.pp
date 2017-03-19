# == Type: Dovecot::ConfigEntries
#
# Config type for a single config entry with a comment
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
type Dovecot::CommentedConfigEntry = Struct[{
    comment => String,
    value   => Dovecot::ConfigEntry,
}]

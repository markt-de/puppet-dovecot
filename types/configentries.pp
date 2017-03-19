# == Type: Dovecot::ConfigEntries
#
# Config type which represents a list of config entries, the
# keys being config names / section types / filter types.
# The values are either simple config values, or for sections
# and filters hashes mapping named sections/filters to config
# entries.
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
type Dovecot::ConfigEntries = Hash[String, Variant[Dovecot::ConfigEntry, Dovecot::CommentedConfigEntry]]

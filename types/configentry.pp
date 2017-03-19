# == Type: Dovecot::ConfigEntry
#
# Config type which represents the value of a single config entry,
# possibly in the form of comment and a value.
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
type Dovecot::ConfigEntry = Variant[Dovecot::ConfigValue, Dovecot::ConfigSection]

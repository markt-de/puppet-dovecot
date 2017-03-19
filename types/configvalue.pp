# == Type: Dovecot::ConfigValue
#
# Value type for the right hand side of a config key.
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
type Dovecot::ConfigValue = Variant[String, Numeric, Boolean, Undef]

# == Type: Dovecot::Config
#
# Config type which represents a single config file with its
# entries and includes.
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
type Dovecot::Config = Struct[{
  entries  => Dovecot::ConfigEntries,
  Optional[includes] => Dovecot::ConfigIncludes,
}]

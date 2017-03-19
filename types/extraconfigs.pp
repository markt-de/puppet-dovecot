# == Type: Dovecot::Config
#
# The main config type, which is a hash whose keys are config 
# file names (the empty string representing the main config)
# and its values are lists of config entries for each file. 
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
type Dovecot::ExtraConfigs = Hash[String, Dovecot::ConfigEntries]

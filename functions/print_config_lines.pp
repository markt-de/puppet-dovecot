# == Function: dovecot::print_config_lines()
#
# Generates the lines of a dovecot config file from the given entry
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
function dovecot::print_config_lines(String $name, $value, $indent = '') {
  case $value {
    Dovecot::CommentedConfigEntry: {
      $value['comment'] ? {
        Undef   => [],
        default => split($value['comment'], '\n').map |$commentline| {
          "${indent}# $commentline"
        }
      } + dovecot::print_config_lines($name, $value['value'], $indent)
    }
    Dovecot::ConfigValue: {
      $quotedValue = $value ? {
        Undef   => '',
        ''      => '""',
        true    => 'yes',
        false   => 'no',
        /[#\s]/ => "\"${value}\"",
        default => $value
      }
      [ "${indent}${name} = ${quotedValue}" ]
    }
    Hash: { # should be Dovecot::ConfigSection, but that doesn't match properly for unknown reasons
      ["${indent}${name} {"] +
      $value.map |$entryName, $entryValue| {
        dovecot::print_config_lines($entryName, $entryValue, "  ${indent}")
      }.reduce([]) |$a, $b| { $a + $b } +
      [ "${indent}}" ]
    }
    default: {
      fail("Invalid config entry type for key ${name}, this should not happen: ${type($value)}")
    }
  }
}

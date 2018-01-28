# Function: dovecot::print_config_value()
# ===================
#
# @summary returns a properly quoted dovecot config value
# @param value the value to be printed
#
# @return the formatted config value suitable for inclusion in a dovecot config file
#
# @see dovecot::config
# @see dovecot::rmilter::config
#
# @author Bernhard Frauendienst <puppet@nospam.obeliks.de>
#
function dovecot::print_config_value($value) {
  $value ? {
    Undef   => '',
    ''      => '""',
    true    => 'yes',
    false   => 'no',
    /(#|\n|\A\s+|\s+\z)/ => "\"${value}\"",
    default => $value,
  }
}

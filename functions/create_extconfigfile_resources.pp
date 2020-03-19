# Function: dovecot::create_extconfigfile_resources()
# =============
#
# @summary create {dovecot::extconfigfile} resources from a nested hash (e.g. from hiera)
#
# Create {dovecot::extconfigfile} resources from a nested hash, suitable for
# conveniently loading values from hiera.
#
# The first level of keys is the config files to be written to, the
# values being the hierarchical values that will be passed to the extconfigfile 
# resource.
#
# Values can either be a Hash[String, String], or a hash containing two properties
# `entries` and `additional_content`.
#
# @param configfile_hash a hash of config file names mapped to config hashes
#
# @see dovecot::extconfigfile
#
# @author Bernhard Frauendienst <puppet@nospam.obeliks.de>
#
function dovecot::create_extconfigfile_resources(
  Hash[String, Hash] $configfile_hash,
) {
  $dovecot::extconfigs.each|$key, $value| {
    case $value {
      Hash[String, String]: {
        $_entries = $value
        $_additional_content = undef
      }
      Struct[{
        entries => Hash[String, String],
        Optional[additional_content] => Optional[String],
      }]: {
        $_entries = $value[entries]
        $_additional_content = $value[additional_content]
      }
      default: { fail("Unsupported value type for extconfigfile: ${value}") }
    }

    dovecot::extconfigfile { $key:
      entries            => $_entries,
      additional_content => $_additional_content,
      relpath            => $key,
    }
  }
}

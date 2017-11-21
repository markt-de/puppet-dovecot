# @api private 
# This class handles packages. Avoid modifying private classes.
class dovecot::install inherits dovecot {
  if ($dovecot::package_manage) {
    package { $dovecot::package_name:
      ensure => $dovecot::package_ensure,
    }

    # get a list of package names for all requested plugins
    $_list = $dovecot::plugins.map |$_plugin| {
      if ($dovecot::plugin[$_plugin]) {
        if ($dovecot::plugin[$_plugin]['package_name']) {
          $dovecot::plugin[$_plugin]['package_name']
        }
      }
    }

    # remove duplicates from the list
    $packages = unique($_list)

    # install plugin packages
    $packages.each |$_package| {
      package { $_package:
        ensure => $dovecot::package_ensure,
      }
    }
  }
}

# @api private 
# This class handles services. Avoid modifying private classes.
class dovecot::service inherits dovecot {
  if ($dovecot::service_manage) {
    service { $dovecot::service_name:
      ensure => $dovecot::service_ensure,
      enable => $dovecot::service_enable,
    }
  }
}

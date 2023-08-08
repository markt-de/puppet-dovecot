# @summary This class handles services.
# @api private 
class dovecot::service inherits dovecot {
  if ($dovecot::service_manage) {
    service { $dovecot::service_name:
      ensure => $dovecot::service_ensure,
      enable => $dovecot::service_enable,
    }
  }
}

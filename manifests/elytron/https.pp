#
# Configures HTTPS using elytron subsystem
#
define wildfly::elytron::https (
  $keystore_path,
  $keystore_relative_to    = undef,
  $keystore_password       = undef,
  $enabled_protocols       = ["TLSv1.2"],
  $cipher_suite_filter     = 'DEFAULT',
  $use_cipher_suites_order = false,
  $want_client_auth        = false,
  $need_client_auth        = false,
  $authentication_optional = false
) {

  wildfly::resource { "/subsystem=elytron/key-store=${title}-KS":
    content => {
      'path'                => $keystore_path,
      'relative-to'         => $keystore_relative_to,
      'type'                => 'JKS',
      'credential-reference' => {
        'clear-text' => $keystore_password
      }
    }
  }
  ->
  wildfly::resource { "/subsystem=elytron/key-manager=${title}-KM":
    content => {
      'key-store'           => "${title}-KS",
      'credential-reference' => {
        'clear-text' => $keystore_password
      }
    }
  }
  ->
  wildfly::resource { "/subsystem=elytron/server-ssl-context=${title}-SSC":
    content => {
      'key-manager'             => "${title}-KM",
      'protocols'               => $enabled_protocols,
      'cipher-suite-filter'     => $cipher_suite_filter,
      'use-cipher-suites-order' => $use_cipher_suites_order,
      'want-client-auth'        => $want_client_auth,
      'need-client-auth'        => $need_client_auth,
      'authentication-optional' => $authentication_optional,
      'credential-refrence'     => {
        'clear-text' => $keystore_password
      }
    }
  }
  ->
  wildfly::resource { "/subsystem=undertow/server=default-server/https-listener=https":
    undefine_attributes => true,
    content => {
      'ssl-context' => "${title}-SSC",
      'security-realm' => undef
    }
  }

  # Define resource that can be called to reload the keystore, e.g. when certs change.
  wildfly::cli { "${title}-KS-Reload":
    command     => "/subsystem=elytron/key-store=${title}-KS:load",
    refreshonly => true,
    require     => Wildfly::Resource["/subsystem=elytron/key-store=${title}-KS"]
  }

}

#
# Add an SASL Authentication Factory in the elytron subsystem
#
define wildfly::elytron::sasl_authentication_factory (
  String $security_domain,
  String $sasl_server_factory             = 'configured',
  Array[Hash] $mechanisms                   = [],
) {

  wildfly::resource { "/subsystem=elytron/http-authentication-factory=${title}":
    content => {
      'security-domain'         => $security_domain,
      'sasl-server-factory' => $sasl_server_factory,
      'mechanism-configurations'    => $mechanisms
    }
  }

}

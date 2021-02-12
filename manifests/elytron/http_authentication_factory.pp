#
# Add an HTTP Authentication Factory in the elytron subsystem
#
define wildfly::elytron::http_authentication_factory (
  String $security_domain,
  String $http_server_mechanism_factory             = 'global',
  Array[Hash] $mechanisms                   = [],
) {

  wildfly::resource { "/subsystem=elytron/http-authentication-factory=${title}":
    content => {
      'security-domain'         => $security_domain,
      'http-server-mechanism-factory' => $http_server_mechanism_factory,
      'mechanism-configurations'    => $mechanisms
    }
  }

}

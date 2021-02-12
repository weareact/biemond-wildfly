#
# Add a Security Domain in the elytron subsystem
#
define wildfly::elytron::security_domain (
  String $default_realm,
  String $permission_mapper             = 'default-permission-mapper',
  Array[Hash] $realms                   = [],
) {

  wildfly::resource { "/subsystem=elytron/security-domain=${title}":
    content => {
      'default-realm'         => $default_realm,
      'permission-mapper' => $permission_mapper,
      'realms'    => $realms
    }
  }

}

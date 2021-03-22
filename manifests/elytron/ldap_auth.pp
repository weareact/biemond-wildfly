#
# Configures Base LDAP resources for quick LDAP connectivity using elytron subsystem
#
define wildfly::elytron::ldap_auth (
  String $url,
  String $directory_base,
  String $application_realm_name,
  Enum['ldap', 'active_directory'] $directory_type          = 'ldap',
  String $user_search_base                                  = $directory_base,
  String $group_search_base                                 = "ou=groups,${directory_base}",
  Enum['FORM', 'DIGEST', 'BASIC'] $authentication_mechanism = 'FORM',
  Boolean $apply_to_default_server                          = true,
  Optional[String] $principal_user                          = undef,
  Optional[String] $principal_password                      = undef,
) {

  ensure_resource('wildfly::resource', "/subsystem=elytron/simple-role-decoder=from-roles-attribute", {
    content => {
      'attribute' => 'Roles',
    }
  })

  wildfly::elytron::directory_context { "${title}-DC":
    url                => $url,
    principal_user     => $principal_user,
    principal_password => $principal_password,
  } ->
  wildfly::elytron::ldap_realm { "${title}-LR":
    directory_context => "${title}-DC",
    directory_base    => $directory_base,
    directory_type    => $directory_type,
  } ->
  wildfly::elytron::security_domain { "${title}-SD":
    default_realm => "${title}-LR",
    realms        => [{
      'realm'        => "${title}-LR",
      'role-decoder' => "from-roles-attribute"
    }],
  } ->
  wildfly::elytron::http_authentication_factory { "${title}-HAF":
    security_domain => "${title}-SD",
    mechanisms      => [{
      'mechanism-name'                 => $authentication_mechanism,
      'mechanism-realm-configurations' => [{
        'realm-name' => $application_realm_name
      }]
    }],
  }

  if $apply_to_default_server {
    wildfly::resource { "/subsystem=undertow/server=default-server/host=default-host/setting=http-invoker":
      undefine_attributes => true,
      content             => {
        'security-realm' => undef,
        'http-authentication-factory' => "${title}-HAF"
      },
      require             => Wildfly::Elytron::Http_authentication_factory["${title}-HAF"]
    } ->
    wildfly::resource { "/subsystem=undertow/application-security-domain=${application_realm_name}":
      content             => {
        'http-authentication-factory' => "${title}-HAF"
      }
    } ->
    wildfly::resource { "/subsystem=ejb3/application-security-domain=${application_realm_name}":
      content => {
        'security-domain' => "${title}-SD"
      }
    }
  }
}

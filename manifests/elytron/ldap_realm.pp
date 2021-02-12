#
# Add an LDAP Realm in the elytron subsystem
#
define wildfly::elytron::ldap_realm (
  String $directory_context,
  String $directory_base,
  Enum['ldap', 'active_directory'] $directory_type = 'ldap',
  String $user_search_base                         = $directory_base,
  String $group_search_base                        = "ou=groups,${directory_base}",
  Boolean $direct_verification                     = true,
  Boolean $allow_blank_password                    = false,
  Boolean $recursive_user_search                   = true,
  Integer $recursive_group_search_limit            = 10,
  Optional[String] $user_identifer                 = undef,
) {

  if $directory_type == 'active_directory' {
    if $user_identifer == undef {
      $_user_identifier = 'sAMAccountName'
    }
    else {
      $_user_identifier = $user_identifer
    }

    $_attribute_mappings = [{
      'from'           => 'cn',
      'to'             => 'Roles',
      'filter'         => "(&(objectClass=group)(member={1}))",
      'filter-base-dn' => $group_search_base,
      'role-recursion' => $recursive_group_search_limit
    }]
  }
  else {
    if $user_identifer == undef {
      $_user_identifier = 'uid'
    }
    else {
      $_user_identifier = $user_identifer
    }

    $_attribute_mappings = [{
      'from'           => 'cn',
      'to'             => 'Roles',
      'filter'         => "(&(objectClass=groupOfUniqueNames)(uniqueMember={1}))",
      'filter-base-dn' => $group_search_base,
      'role-recursion' => $recursive_group_search_limit
    }]
  }

  wildfly::resource { "/subsystem=elytron/ldap-realm=${title}":
    content => {
      'dir-context'         => $directory_context,
      'direct-verification' => $direct_verification,
      'identity-mapping'    => {
        'rdn-identifier'       => $_user_identifer,
        'use-recursive-search' => $recursive_user_search,
        'search-base-dn'       => $user_search_base,
        'attribute-mapping'    => $_attribute_mappings
      }
    }
  }

}

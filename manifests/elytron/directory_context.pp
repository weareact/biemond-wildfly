#
# Add a Directory Context in the elytron subsystem
#
define wildfly::elytron::directory_context (
  String $url,
  Enum['ignore', 'follow', 'throw'] $referral_mode = 'ignore',
  Optional[String] $principal_user                 = undef,
  Optional[String] $principal_password             = undef,
) {

  wildfly::resource { "/subsystem=elytron/dir-context=${title}":
    content => {
      'url'                  => $url,
      'referral-mode'        => $referral_mode,
      'principal'            => $principal_user,
      'credential-reference' => {
        'clear-text' => $principal_password
      }
    }
  }

}

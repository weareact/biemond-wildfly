#
# Configures a connection factory
#
define wildfly::messaging::activemq::connection_factory(
  Optional[String] $entries = undef,
  Optional[String] $connectors = undef,
  Optional[String] $target_profile = undef
) {

  $params = {
    'entries' => $entries,
    'connectors' => $connectors
  }

  wildfly::resource { "/subsystem=messaging-activemq/server=default/connection-factory=${title}":
    content => $params,
    profile => $target_profile,
  }

}

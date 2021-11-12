#
# Configures a pooled connection factory
#
define wildfly::messaging::activemq::pooled_connection_factory(
  Optional[String] $entries = undef,
  Optional[String] $connectors = undef,
  Optional[String] $transaction = undef,
  Optional[String] $target_profile = undef
) {

  $params = {
    'entries' => $entries,
    'connectors' => $connectors,
    'transaction' => $transaction
  }

  wildfly::resource { "/subsystem=messaging-activemq/server=default/pooled-connection-factory=${title}":
    content => $params,
    profile => $target_profile,
  }

}

#
# Configures a pooled connection factory
#
define wildfly::messaging::activemq::pooled_connection_factory(
  $entries = undef,
  $connectors = undef,
  $transaction = undef,
  $target_profile = undef) {

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

#
# Configures a queue
#
define wildfly::messaging::activemq::queue(
  Optional[Array[String]] $entries = undef,
  Optional[String] $durable = undef,
  Optional[String] $selector = undef,
  Optional[String] $target_profile = undef
) {

  $params = {
    'durable' => $durable,
    'entries' => $entries,
    'selector' => $selector
  }

  wildfly::resource { "/subsystem=messaging-activemq/server=default/jms-queue=${title}":
    content => $params,
    profile => $target_profile,
  }

}

define bind::view ( $match_destinations = [],
                    $match_clients = [],
                  # options
                    $forwarders='',
                    $querysource_address='',
                    $querysourcev6_address='',
                    $querysource_port='',
                  # zones
                    $zones = []) {

  concat::fragment {
    "view_include_$name":
      target  => '/etc/named.conf',
      order   => 30,
      content => "include \"/etc/named.d/views/$name.conf\";\n";
  }

  file {
    "/etc/named.d/views/$name.conf":
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      notify  => Service['named'],
      content => template('bind/view.erb');
  }

}

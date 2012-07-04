define bind::zone::forward ($forwarders) {

  include bind

  file {
    "/etc/named.d/zones/$name.conf":
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      notify  => Service['named'],
      content => template('bind/zone_forward.erb');
  }

}

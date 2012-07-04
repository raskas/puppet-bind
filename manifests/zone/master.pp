define bind::zone::master ( $zone_name=$name,
                            $zone_ns,
                            $zone_contact,
                            $zone_serial,
                            $zone_refresh,
                            $zone_retry,
                            $zone_expiracy,
                            $zone_ttl,
                            $filename='') {

  include bind
  include concat::setup

  file {
    "/etc/named.d/zones/$name.conf":
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      notify  => Service['named'],
      content => template('bind/zone_master.erb');
  }

  if $filename == '' {
    $full_filename = inline_template('/var/named/zone.<%= name %>')
  } else {
    $full_filename = inline_template('/var/named/<%= filename %>')
  }

  concat {
    $full_filename:
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      require => Package['bind'],
      notify  => Service['named'];
  }

  concat::fragment {
    "zone_header_$name":
      target  => $full_filename,
      order   => 0,
      content => template('bind/zone_header.erb');
  }

}

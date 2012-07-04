class bind ($forwarders="",
            $querysource_address="",
            $querysource_port="") {

  package {
    "bind":
      ensure => installed;
  }

  service {
    "named":
      ensure    => running,
      enable    => true,
      hasstatus => true,
      require   => Package["bind"];
  }

  include concat::setup

  concat {
    "/etc/named.conf":
      owner  => "root",
      group  => "root",
      mode   => 0644,
      notify => Service["named"];
  }

  concat::fragment {
    "named_options":
      target  => "/etc/named.conf",
      order   => 0,
      content => template("bind/options.erb");
  }

}

define bind::zone::forward ($forwarders) {

  include bind

  concat::fragment {
    "zone_forward_$name":
      target  => "/etc/named.conf",
      order   => 10,
      content => template("bind/zone_forward.erb");
  }

}

define bind::zone::master ($filename="",
                           $zone_ns,
                           $zone_contact,
                           $zone_serial,
                           $zone_refresh,
                           $zone_retry,
                           $zone_expiracy,
                           $zone_ttl) {

  include bind
  include concat::setup

  concat::fragment {
    "zone_master_$name":
      target  => "/etc/named.conf",
      order   => 20,
      content => template("bind/zone_master.erb");
  }

  if $filename == '' {
    $full_filename = inline_template("/var/named/zone.<%= name %>")
  } else {
    $full_filename = inline_template("/var/named/<%= filename %>")
  }

  concat {
    "$full_filename":
      owner  => "root",
      group  => "root",
      mode   => 0644,
      notify => Service["named"];
  }

  concat::fragment {
    "zone_header_$name":
      target  => "$full_filename",
      order   => 0,
      content => template("bind/zone_header.erb");
  }

}

define bind::record ($filename="",
                     $zone="",
                     $record_class,
                     $record_type,
                     $ttl=false,
                     $host){

  if $filename == '' {
    $full_filename = inline_template("/var/named/zone.<%= zone %>")
  } else {
    $full_filename = inline_template("/var/named/<%= filename %>")
  }

  concat::fragment {
    "zone_record_${record_type}_${name}":
      target  => "$full_filename",
      order   => 20,
      content => template("bind/default-record.erb");
  }

}

define bind::record::a ($filename="",
                        $zone="",
                        $ttl=false,
                        $host) {

  bind::record {
    "$name":
      filename     => $filename,
      zone         => $zone,
      record_class => "IN",
      record_type  => "A",
      ttl          => $ttl,
      host         => $host;
  }

}

define bind::record::ptr ($filename="",
                        $zone="",
                        $ttl=false,
                        $host) {

  bind::record {
    "$name":
      filename     => $filename,
      zone         => $zone,
      record_class => "IN",
      record_type  => "PTR",
      ttl          => $ttl,
      host         => $host;
  }

}

define bind::record ( $hostname=$name,
                      $host,
                      $record_class,
                      $record_type,
                      $filename='',
                      $zone='',
                      $ttl=false){

  if $filename == '' {
    $full_filename = inline_template('/var/named/zone.<%= zone %>')
  } else {
    $full_filename = inline_template('/var/named/<%= filename %>')
  }

  concat::fragment {
    "zone_record_${record_type}_${name}":
      target  => $full_filename,
      order   => 20,
      content => template('bind/default-record.erb');
  }

}

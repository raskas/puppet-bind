define bind::record::ptr ($hostname=$name,
                          $host,
                          $filename='',
                          $zone='',
                          $ttl=false) {

  bind::record {
    $name:
      hostname     => $hostname,
      filename     => $filename,
      zone         => $zone,
      record_class => 'IN',
      record_type  => 'PTR',
      ttl          => $ttl,
      host         => $host;
  }

}

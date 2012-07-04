define bind::record::a ($hostname=$name,
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
      record_type  => 'A',
      ttl          => $ttl,
      host         => $host;
  }

}

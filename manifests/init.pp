class bind ($forwarders='',
            $querysource_address='',
            $querysourcev6_address='',
            $querysource_port='',
            $zones = []) {

  package {
    'bind':
      ensure => installed;
    'bind-utils':
      ensure => installed;
  }

  service {
    'named':
      ensure    => running,
      enable    => true,
      hasstatus => true,
      restart   => '/etc/init.d/named reload',
      require   => Package['bind'];
  }

  file {
    '/etc/named.d/':
      ensure  => directory,
      recurse => true,
      purge   => true,
      force   => true;
    '/etc/named.d/views/':
      ensure  => directory,
      recurse => true,
      purge   => true,
      force   => true;
    '/etc/named.d/zones/':
      ensure  => directory,
      recurse => true,
      purge   => true,
      force   => true;
  }

  include concat::setup

  concat {
    '/etc/named.conf':
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
      notify => Service['named'];
  }

  concat::fragment {
    'named_options':
      target  => '/etc/named.conf',
      order   => 0,
      content => template('bind/options.erb');
  }

}

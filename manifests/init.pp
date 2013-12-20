
class galera (
  $cluster_name                = 'galera',
  $master_ip                   = false,
  $package_name                = 'galera',
  $wsrep_provider              = '/usr/lib/galera/libgalera_smm.so',
  $wsrep_node_name             = $::hostname,
  $wsrep_node_address          = $::ipaddress,
  $wsrep_node_incoming_address = $::ipaddress,
  $wsrep_notify_cmd            = '',
  $wsrep_sst_method            = 'xtrabackup',
  $wsrep_sst_auth              = 'root:root',
  $wsrep_sst_receive_address   = $::ipaddress,
  $wsrep_sst_donor             = $::hostname,) {
  package { 'galera':
    ensure  => present,
    name    => $package_name,
    require => Package['mysql_client'],
  }

  file { '/etc/mysql/conf.d/wsrep.cnf':
    ensure  => present,
    content => template('galera/wsrep.cnf.erb'),
    require => Package['galera'],
    before  => Class['::mysql::server::service'],
  }

}

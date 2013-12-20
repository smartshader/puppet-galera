
class galera (
  $cluster_name                = 'galera',
  $master_ip                   = false,
  $package_name                = 'galera',
  $mysql_bind_address          = '0.0.0.0',
  $wsrep_provider              = '/usr/lib/galera/libgalera_smm.so',
  $wsrep_provider_options      = '',
  $wsrep_node_name             = $::hostname,
  $wsrep_node_address          = $::ipaddress,
  $wsrep_node_incoming_address = $::ipaddress,
  $wsrep_notify_cmd            = '',
  $wsrep_sst_method            = 'xtrabackup',
  $wsrep_sst_auth_user         = 'root',
  $wsrep_sst_auth_password     = 'root',
  $wsrep_sst_auth              = '',
  $wsrep_sst_receive_address   = $::ipaddress,
  $wsrep_sst_donor             = $::hostname,) {
  # validate parameters
  validate_string($wsrep_sst_auth_user)
  validate_string($wsrep_sst_auth_password)
  validate_string($wsrep_sst_auth)
  validate_string($cluster_name)
  validate_string($package_name)
  validate_string($wsrep_sst_method)
  validate_string($wsrep_node_name)

  validate_absolute_path($wsrep_provider)

  if empty($wsrep_sst_auth_user) and empty($wsrep_sst_auth_password) and !empty($wsrep_sst_auth) {
    $real_wsrep_sst_auth = $wsrep_sst_auth
  } else {
    $real_wsrep_sst_auth = "${wsrep_sst_auth_user}:${wsrep_sst_auth_password}"
  }

  mysql_user { "${wsrep_sst_auth_user}@%":
    ensure        => present,
    password_hash => mysql_password($wsrep_sst_auth_password),
    require       => Class['::mysql::server::service'],
  }

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
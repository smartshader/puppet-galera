
class galera (
  $cluster_name                = 'galera',
  $package_name                = 'galera',
  $mysql_package               = 'mysql-server',
  $mysql_bind_address          = '0.0.0.0',
  $mysql_config_directory      = '/etc/mysql/conf.d/',
  $wsrep_master                = true,
  $wsrep_provider              = '/usr/lib/galera/libgalera_smm.so',
  $wsrep_provider_options      = '',
  $wsrep_node_name             = $::hostname,
  $wsrep_node_address          = $::ipaddress,
  $wsrep_node_incoming_address = $::ipaddress,
  $wsrep_notify_cmd            = '',
  $wsrep_sst_method            = 'xtrabackup-v2',
  $wsrep_sst_auth_user         = 'root',
  $wsrep_sst_auth_password     = 'root',
  $wsrep_sst_auth_host         = 'localhost',
  $wsrep_sst_auth              = '',
  $wsrep_sst_receive_address   = $::ipaddress,
  $wsrep_sst_donor             = '',
  $wsrep_cluster_address       = false,
  $wsrep_slave_threads         = 1,) {
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

  mysql_user { "${wsrep_sst_auth_user}@${wsrep_sst_auth_host}":
    ensure        => present,
    password_hash => mysql_password($wsrep_sst_auth_password),
    require       => Class['::mysql::server::service'],
  }

  mysql_grant { "${wsrep_sst_auth_user}@${wsrep_sst_auth_host}/*.*":
    ensure      => present,
    privileges  => ['CREATE TABLESPACE', 'RELOAD', 'LOCK TABLES', 'REPLICATION CLIENT', 'SUPER'],
    table       => '*.*',
    user        => "${wsrep_sst_auth_user}@${wsrep_sst_auth_host}",
  }

  #if $package_name and $package_name != undef {
    #package { 'galera':
      #ensure  => present,
      #name    => $package_name,
      #require => Package[$mysql_package],
    #}
  #}

  file { "${mysql_config_directory}/wsrep.cnf":
    ensure  => present,
    content => template('galera/wsrep.cnf.erb'),
    #require => Package['galera'],
  }

  if $wsrep_master {
    File["${mysql_config_directory}/wsrep.cnf"] ~> Exec['start-galera-master']
    exec { 'start-galera-master':
      command => 'service mysql stop; service mysql start --wsrep-new-cluster',
      path    => '/bin:/usr/bin:/sbin:/usr/sbin',
      user    => 'root',
    }
  } else {
    File["${mysql_config_directory}/wsrep.cnf"] ~> Exec['start-galera-node']
    exec { 'start-galera-node':
      command => 'service mysql restart',
      path    => '/bin:/usr/bin:/sbin:/usr/sbin',
      user    => 'root',
    }
  }


  # needed for setting progress=1 under [sst] in the galera config file
  package {'pv': ensure => present, }

}

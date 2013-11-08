
class galera (
  $cluster_name     = 'galera',
  $master_ip        = false,
  $wsrep_provider   = '/usr/lib/galera/libgalera_smm.so',
  $wsrep_node_name  = $::hostname,
  $wsrep_notify_cmd = '',
  $wsrep_sst_method = 'xtrabackup',
  $wsrep_sst_auth   = '',) {
  package { "galera":
    ensure  => present,
    require => Package["mysql-client-5.5"],
  }

  file { "/etc/mysql/conf.d/wsrep.cnf":
    ensure  => present,
    content => template("galera/wsrep.cnf.erb"),
    require => Package["galera"],
  }

}

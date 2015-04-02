

#MySQL

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with galera](#setup)
    * [What galera affects](#what-mysql-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with galera](#beginning-with-galera)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

##Overview

The puppet-galera module installs, configures, and manages a mysql galera installation. It is tested with percona xtradb cluster, but should also work with mariadb-galera.

##Module Description

The MySQL module manages both the installation and configuration of MySQL as
well as extends Pupppet to allow management of MySQL resources, such as
databases, users, and grants.

##Backwards Compatibility

This module has just undergone a very large rewrite, the original was written by .  As a result it will no
longer work with the previous classes and configuration as before.  We've
attempted to handle backwards compatibility automatically by adding a
`attempt_compatibility_mode` parameter to the main mysql class.  If you set
this to true it will attempt to map your previous parameters into the new
`mysql::server` class.

###WARNING

This may fail.  It may eat your MySQL server.  PLEASE test it before running it
live.  Even if it's just a no-op and a manual comparision.  Please be careful!

##Setup

###What MySQL affects

* MySQL package.
* MySQL configuration files.
* MySQL service.

###Beginning with MySQL

If you just want a server installing with the default options you can run
`include '::mysql::server'`.  If you need to customize options, such as the root
password or /etc/my.cnf settings then you can also include `mysql::server` and
pass in an override hash as seen below:

```puppet
class { '::mysql::server':
  root_password    => 'strongpassword',
  override_options => { 'mysqld' => { 'max_connections' => '1024' } }
}
```

##Usage

All interaction for the server is done via `mysql::server`.  To install the
client you use `mysql::client`, and to install bindings you can use
`mysql::bindings`.

###Overrides

The hash structure for overrides in `mysql::server` is as follows:

```puppet
$override_options = {
  'section' => {
    'item'             => 'thing',
  }
}
```

For items that you would traditionally represent as:

<pre>
[section]
thing
</pre>

You can just make an entry like `thing => true` in the hash.  MySQL doesn't
care if thing is alone or set to a value, it'll happily accept both.

###Custom configuration

To add custom mysql configuration you can drop additional files into
`/etc/mysql/conf.d/` in order to override settings or add additional ones (if you
choose not to use override_options in `mysql::server`).  This location is
hardcoded into the my.cnf template file.

##Reference

###Classes

####Public classes
* `mysql::server`: Installs and configures MySQL.
* `mysql::server::account_security`: Deletes default MySQL accounts.
* `mysql::server::monitor`: Sets up a monitoring user.
* `mysql::server::mysqltuner`: Installs MySQL tuner script.
* `mysql::server::backup`: Sets up MySQL backups via cron.
* `mysql::bindings`: Installs various MySQL language bindings.
* `mysql::client`: Installs MySQL client (for non-servers).

####Private classes
* `mysql::server::install`: Installs packages.
* `mysql::server::config`: Configures MYSQL.
* `mysql::server::service`: Manages service.
* `mysql::server::root_password`: Sets MySQL root password.
* `mysql::server::providers`: Creates users, grants, and databases.
* `mysql::bindings::java`: Installs Java bindings.
* `mysql::bindings::perl`: Installs Perl bindings.
* `mysql::bindings::python`: Installs Python bindings.
* `mysql::bindings::ruby`: Installs Ruby bindings.
* `mysql::client::install`:  Installs MySQL client.

###Parameters

####mysql::server

#####`root_password`

####mysql::server::backup

#####`backupuser`

MySQL user to create for backing up.

#####`backuppassword`

MySQL user password for backups.

###Providers

####mysql_database

mysql_database can be used to create and manage databases within MySQL:

```puppet
mysql_database { 'information_schema':
  ensure  => 'present',
  charset => 'utf8',
  collate => 'utf8_swedish_ci',
}
mysql_database { 'mysql':
  ensure  => 'present',
  charset => 'latin1',
  collate => 'latin1_swedish_ci',
}
```

##Limitations

This module has been tested on Debian 7

Testing on other platforms has been light and cannot be guaranteed.

#Development

Puppet Labs modules on the Puppet Forge are open projects, and community
contributions are essential for keeping them great. We can’t access the
huge number of platforms and myriad of hardware, software, and deployment
configurations that Puppet is intended to serve.

We want to keep it as easy as possible to contribute changes so that our
modules work in your environment. There are a few guidelines that we need
contributors to follow so that we can have a chance of keeping on top of things.

You can read the complete module contribution guide [on the Puppet Labs wiki.](http://projects.puppetlabs.com/projects/module-site/wiki/Module_contributing)

### Authors

This module is based on work by Jimdo GmbH (https://github.com/Jimdo/puppet-galera)

* Walter Heck

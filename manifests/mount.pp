#
#
#
define profile_gluster::mount (
  Stdlib::Fqdn         $server,
  String               $volume_name,
  Stdlib::AbsolutePath $dir         = $title,
) {
  if ! defined (Class['gluster::client']) and ! defined (Class['gluster::install']) {
    include profile_gluster::repo

    class { 'gluster::client':
      repo    => false,
      require => Class['profile_gluster::repo'],
    }
  }

  if ! defined ( File[$dir] ) {
    exec { $dir:
      path    => $::path,
      command => "mkdir -p ${dir}",
      unless  => "test -d ${dir}",
    }

    file { $dir:
      ensure => directory,
      owner  => root,
      group  => root,
      mode   => '0775',
    }
  }

  gluster::mount { $dir:
    ensure  => 'mounted',
    volume  => "${server}:${volume_name}",
    atboot  => true,
    options => 'noatime,nodev,noexec,nosuid',
    require => File[$dir],
  }
}

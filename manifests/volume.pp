#
#
#
define profile_gluster::volume (
  Array[String]        $bricks,
  Integer              $replica       = 3,
  Optional[Integer]    $stripe        = undef,
  Integer              $arbiter       = 1,
  Array[String]        $options       = [ 'nfs.disable: true' ],
  Boolean              $mount         = true,
  Stdlib::AbsolutePath $mount_basedir = '/gluster',
  Stdlib::Fqdn         $server        = $facts['networking']['fqdn'],
) {
  gluster::volume { $title:
    ensure  => 'present',
    bricks  => $bricks,
    replica => $replica,
    stripe  => $stripe,
    arbiter => $arbiter,
    options => $options,
  }

  if $mount {
    profile_gluster::mount { "${mount_basedir}/${name}":
      server      => $server,
      volume_name => $name,
    }
  }
}

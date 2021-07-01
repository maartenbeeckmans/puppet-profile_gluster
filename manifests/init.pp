#
#
#
class profile_gluster (
  Stdlib::Absolutepath $data_path,
  Stdlib::Absolutepath $data_device,
  String               $pool,
  String               $release,
  String               $version,
  Hash                 $volumes,
  Boolean              $backup,
  String               $sd_service_name,
  Array[String]        $sd_service_tags,
  Boolean              $manage_sd_service = lookup('manage_sd_service', Boolean, first, true),
) {

  profile_base::mount{ $data_path:
    device => $data_device,
    mkdir  => true,
  }
  -> class { 'profile_gluster::repo': }
  -> class { 'gluster':
    server  => true,
    client  => true,
    repo    => false,
    pool    => $pool,
    release => $release,
    version => $version,
  }

  create_resources(profile_gluster::volume, $volumes)

  Firewall {
    proto  => 'tcp',
    action => 'accept',
    chain  => 'INPUT',
  }

  firewall { '24007 accept Gluster Deamon':
    dport => 24007,
  }

  firewall { '24007 accept Gluster Management':
    dport => 24008,
  }

  firewall { '49152 accept Gluster Volumes':
    dport => '49152-49251',
  }

  firewall { '38465 accept Gluster NFS':
    dport => '38465-38467',
  }

  if $backup {
    include profile_gluster::backup
  }

  if $manage_sd_service {
    consul::service { $sd_service_name:
      checks => [
        {
          tcp      => "${facts[networking][ip]}:24007",
          interval => '10s',
        }
      ],
      port   => 24007,
      tags   => $sd_service_tags,
    }
  }
}

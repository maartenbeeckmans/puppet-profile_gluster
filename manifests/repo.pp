#
#
#
class profile_gluster::repo (
  String $location,
  String $apt_key_id,
  String $apt_key_source,
) {
  apt::source { 'gluster':
    ensure       => present,
    location     => $location,
    release      => $facts['os']['distro']['codename'],
    repos        => 'main',
    key          => {
      id         => $apt_key_id,
      key_source => $apt_key_source,
    },
    architecture => 'amd64',
  }
}

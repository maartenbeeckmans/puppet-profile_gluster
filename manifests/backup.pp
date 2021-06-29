#
#
#
class profile_gluster::backup (
  Stdlib::AbsolutePath $data_path = $::profile_gluster::data_path,
) {
  include profile_rsnapshot::user

  @@rsnapshot::backup{ "backup ${facts['networking']['fqdn']} gluster-data":
    source     => "rsnapshot@${facts['networking']['fqdn']}:${data_path}",
    target_dir => "${facts['networking']['fqdn']}/gluster-data",
    tag        => lookup('rsnapshot_tag', String, undef, 'rsnapshot'),
  }
}

class rancher_infra::ci::scheduled_master_branch::provision(
  Pattern[/^[a-z]{2}\-[a-z]+\-\d+$/]  $aws_region,
  Pattern[/^[a-e]$/]                  $aws_zone,
  Pattern[/^.+$/]                     $mysql_root_password,
  Pattern[/^.+$/]                     $rancher_version,
  Pattern[/^.+$/]                     $ssh_key, # this must already exist!
  ) {

  $tags = { 'is_ci' => 'true', 'ci' => 'scheduled_master_branch', 'owner' => $::id }

  class { '::rancher_infra::ci::scheduled_master_branch::provision::network': } ->
#  class { '::rancher_infra::ci::scheduled_master_branch::provision::database': } ~>
#  class { '::rancher_infra::ci::scheduled_master_branch::provision::instances': } ~>
#  class { '::rancher_infra::ci::scheduled_master_branch::provision::lb': } ->
  Class['::rancher_infra::ci::scheduled_master_branch::provision']
}

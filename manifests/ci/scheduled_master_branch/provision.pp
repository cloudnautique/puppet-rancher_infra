class rancher_infra::ci::scheduled_master_branch::provision(
  Pattern[/^[a-z]{2}\-[a-z]+\-\d+$/]  $aws_region,
  Pattern[/^[a-e]$/]                  $aws_zone,
  Pattern[/^ami\-.+$/]                $default_ami,
  Pattern[/^.+$/]                     $ssh_key, # this must already exist!
  Enum['absent', 'present', 'agents'] $ensure,
  Hash[String, String]                $tags,
  ) {

  case $ensure {
    'present': {
      class { '::rancher_infra::ci::scheduled_master_branch::provision::network': } ->
      class { '::rancher_infra::ci::scheduled_master_branch::provision::instances': } ~>
      Class['::rancher_infra::ci::scheduled_master_branch::provision']
    }

    'agents': {
      class { '::rancher_infra::ci::scheduled_master_branch::provision::instances_agents': } ->
      Class['::rancher_infra::ci::scheduled_master_branch::provision']
    }
  }
}

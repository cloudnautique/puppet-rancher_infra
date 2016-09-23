class rancher_infra::ci::scheduled_master_branch::deprovision(
  Pattern[/^[a-z]{2}\-[a-z]+\-\d+$/]  $aws_region,
  Pattern[/^[a-e]$/]                  $aws_zone,
  ) {

#  class { '::rancher_infra::ci::scheduled_master_branch::deprovision::lb': } ->
  class { '::rancher_infra::ci::scheduled_master_branch::deprovision::instances': } ~>
  class { '::rancher_infra::ci::scheduled_master_branch::deprovision::network': } ->
  Class['::rancher_infra::ci::scheduled_master_branch::deprovision']
}

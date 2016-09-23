class rancher_infra::ci::on_tag::provision(
  Pattern[/^.+$/]                     $uuid,
  Pattern[/^[a-z]{2}\-[a-z]+\-\d+$/]  $aws_region,
  Pattern[/^[a-e]$/]                  $aws_zone,
  Pattern[/^.+$/]                     $ssh_key, # this must already exist!
  Enum['absent', 'present', 'agents'] $ensure,
  Hash[String, String]                $tags,
  ) {

  case $ensure {
    'present': {
      class { '::rancher_infra::ci::on_tag::provision::network': } ->
      Class['::rancher_infra::ci::on_tag::provision']
    }

    'agents': {
      class { '::rancher_infra::ci::on_tag::provision::instances_agents': } ->
      Class['::rancher_infra::ci::on_tag::provision']
    }
  }
}

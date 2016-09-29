class rancher_infra::ci::validation_tests::provision(
  Pattern[/^[a-z]{2}\-[a-z]+\-\d+$/]  $aws_region,
  Pattern[/^[a-e]$/]                  $aws_zone,
  Pattern[/^.+$/]                     $ssh_key, # this must already exist!
  Enum['absent', 'present', 'agents'] $ensure,
  Hash[String, String]                $tags,
  ) {

  class { '::rancher_infra::ci::validation_tests::provision::network': } ->
  Class['::rancher_infra::ci::validation_tests::provision']
}

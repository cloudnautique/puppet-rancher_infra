class rancher_infra::ci::validation_tests(
  Pattern[/^[a-z]{2}\-[a-z]+\-\d+$/]            $aws_region          = $::rancher_infra::aws_region,
  Pattern[/^[a-e]$/]                            $aws_zone            = $::rancher_infra::aws_zone,
  Pattern[/^.+$/]                               $ssh_key             = $::rancher_infra::default_ssh_key,
  Hash[String, String]                          $default_tags        = { 'is_ci' => 'true' },
  ) {
  require ::rancher_infra::ci 
}

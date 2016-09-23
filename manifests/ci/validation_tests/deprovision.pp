class rancher_infra::ci::validation_tests::deprovision(
  Pattern[/^.+$/]                     $uuid,
  Pattern[/^[a-z]{2}\-[a-z]+\-\d+$/]  $aws_region,
  ) {

  class { '::rancher_infra::ci::validation_tests::deprovision::network':
    uuid => $uuid,
    aws_region => $aws_region,
  } ->
  Class['::rancher_infra::ci::validation_tests::deprovision']
}

class rancher_infra::ci::scheduled_master_branch::deprovision::instances(
  Pattern[/^[a-z]{2}\-[a-z]+\-\d+$/]  $aws_region = $::rancher_infra::ci::scheduled_master_branch::deprovision::aws_region,
  Pattern[/^[a-e]$/]                  $aws_zone = $::rancher_infra::ci::scheduled_master_branch::deprovision::aws_zone,
  ) {

  ec2_instance {
    [ 'ci-scheduled-master-branch0', ]:
        ensure => absent,
        region => $aws_region,
        availability_zone => "${aws_region}${aws_zone}",
  }
}

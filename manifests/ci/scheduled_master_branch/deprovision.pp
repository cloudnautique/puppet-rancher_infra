class rancher_infra::ci::scheduled_master_branch::deprovision(
  Pattern[/^[a-z]{2}\-[a-z]+\-\d+$/]  $aws_region,
  Pattern[/^[a-e]$/]                  $aws_zone,
  ) {

  ec2_instance {
    [ 'ci-scheduled-master-rancher0',
      'ci-scheduled-master-rancher1',
      'ci-scheduled-master-rancher2',
      'ci-scheduled-master-compute0' ]:
        ensure => absent,
        region => $aws_region,
        availability_zone => "${aws_region}${aws_zone}",
  } ->

  rds_instance { 'ci-scheduled-master-rds':
    ensure => absent,
    region => $aws_region,
    availability_zone => "${aws_region}${aws_zone}",
    skip_final_snapshot => true,
  } ->

  ec2_vpc_internet_gateway { 'ci-scheduled-master-vpc-gateway':
    ensure => absent,
    region => $aws_region,
  } ->

  ec2_vpc_routetable { 'ci-scheduled-master-vpc-routing':
    ensure => absent,
    region => $aws_region,
  } ->

  ec2_vpc_subnet { 'ci-scheduled-master-subnet':
    ensure => absent,
    region => $aws_region,
  } ->
    
  ec2_securitygroup { 'ci-scheduled-master-sg':
    ensure => absent,
    region => $aws_region,
  } ->
  
  ec2_vpc { 'ci-scheduled-master-vpc':
    ensure => absent,
    region => $aws_region,
  }
}

class rancher_infra::demo::ha::deprovision(
  Pattern[/^[a-z]{2}\-[a-z]+\-\d+$/]  $aws_region,
  Pattern[/^[a-e]$/]                  $aws_zone,
  ) {

  ec2_instance {
    [ 'ha-demo-rancher0',
      'ha-demo-rancher1',
      'ha-demo-rancher2',
      'ha-demo-compute0' ]:
        ensure => absent,
        region => $aws_region,
        availability_zone => "${aws_region}${aws_zone}",
  } ->

  rds_instance { 'ha-demo-rds':
    ensure => absent,
    region => $aws_region,
    availability_zone => "${aws_region}${aws_zone}",
    skip_final_snapshot => true,
  } ->

  ec2_vpc_internet_gateway { 'ha-demo-vpc-gateway':
    ensure => absent,
    region => $aws_region,
  } ->

  ec2_vpc_routetable { 'ha-demo-vpc-routing':
    ensure => absent,
    region => $aws_region,
  } ->

  ec2_vpc_subnet { 'ha-demo-subnet':
    ensure => absent,
    region => $aws_region,
  } ->
    
  ec2_securitygroup { 'ha-demo-sg':
    ensure => absent,
    region => $aws_region,
  } ->
  
  ec2_vpc { 'ha-demo-vpc':
    ensure => absent,
    region => $aws_region,
  }
}

class rancher_infra::ci::scheduled_master_branch::deprovision::network(
  Pattern[/^[a-z]{2}\-[a-z]+\-\d+$/]  $aws_region = $::rancher_infra::ci::scheduled_master_branch::aws_region,
  ) {

  ec2_vpc_internet_gateway { 'ci-scheduled-master-vpc-gateway':
    ensure => absent,
    region => $aws_region,
  } ->

  ec2_vpc_subnet { 'ci-scheduled-master-subnet':
    ensure => absent,
    region => $aws_region,
  } ->

  ec2_vpc_routetable { 'ci-scheduled-master-subnet-routing':
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

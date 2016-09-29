class rancher_infra::ci::validation_tests::deprovision::network(
  Pattern[/^.+$/]                     $uuid = $::rancher_infra::ci::validation_tests::deprovision::uuid,
  Pattern[/^[a-z]{2}\-[a-z]+\-\d+$/]  $aws_region = $::rancher_infra::ci::validation_tests::aws_region,
  ) {

  Ec2_vpc_internet_gateway { "ci-validation-tests-vpc-gateway":
    ensure => absent,
    region => $aws_region,
  } ->

  ec2_vpc_subnet { "ci-validation-tests-subnet":
    ensure => absent,
    region => $aws_region,
  } ->

  ec2_vpc_routetable { "ci-validation-tests-subnet-routing":
    ensure => absent,
    region => $aws_region,
  } ->
    
  ec2_securitygroup { "ci-validation-tests-sg":
    ensure => absent,
    region => $aws_region,
  } ->
  
  ec2_vpc { "ci-validation-tests-vpc":
    ensure => absent,
    region => $aws_region,
  }
}

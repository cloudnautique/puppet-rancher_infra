class rancher_infra::ci::validation_tests::provision::network(
  Pattern[/^.+$/]                     $uuid = $::rancher_infra::ci::validation_tests::provision::uuid,
  Pattern[/^[a-z]{2}\-[a-z]+\-\d+$/]  $aws_region = $::rancher_infra::ci::validation_tests::provision::aws_region,
  Pattern[/^[a-e]$/]                  $aws_zone = $::rancher_infra::ci::validation_tests::provision::aws_zone,
  Hash[String, String]                $tags = $::rancher_infra::ci::validation_tests::provision::tags,
  ) {

  $vpc_cidr_block = '172.16.0.0/16'
  $subnet_cidr_block = '172.16.100.0/24'

  ec2_vpc { "${uuid}-ci-validation-tests-vpc":
    ensure => present,
    cidr_block => $vpc_cidr_block,
    instance_tenancy => 'default',
    region => $aws_region,
    tags => $tags,
  }
    
  ec2_vpc_routetable { "${uuid}-ci-validation-tests-subnet-routing":
    ensure => present,
    region => $aws_region,
    vpc => "${uuid}-ci-validation-tests-vpc",
    routes => [
      {
        destination_cidr_block => $vpc_cidr_block,
        gateway => 'local',
      },
      {
        destination_cidr_block => '0.0.0.0/0',
        gateway => "${uuid}-ci-validation-tests-vpc-gateway",
      },
    ],
  }

  ec2_vpc_subnet { "${uuid}-ci-validation-tests-subnet":
    ensure => present,
    vpc => "${uuid}-ci-validation-tests-vpc",
    region => $aws_region,
    availability_zone => "${aws_region}${aws_zone}",
    cidr_block => $subnet_cidr_block,
    route_table => "${uuid}-ci-validation-tests-subnet-routing",
    tags => $tags,
  } ->

  ec2_securitygroup { "${uuid}-ci-validation-tests-sg":
    ensure => present,
    description => 'SG for Rancher CI nodes',
    region => $aws_region,
    ingress => [
      { security_group => "${uuid}-ci-validation-tests-sg" },
      { protocol => 'tcp', cidr => '0.0.0.0/0' },
      { protocol => 'udp', cidr => '0.0.0.0/0' },
      { protocol => 'icmp', cidr => '0.0.0.0/0' },
    ],
    vpc => "${uuid}-ci-validation-tests-vpc",
    tags => $tags,
  }

  ec2_vpc_internet_gateway { "${uuid}-ci-validation-tests-vpc-gateway":
    ensure => present,
    region => $aws_region,
    vpc => "${uuid}-ci-validation-tests-vpc",
  }
}

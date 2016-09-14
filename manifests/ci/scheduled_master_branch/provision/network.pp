class rancher_infra::ci::scheduled_master_branch::provision::network(
  Pattern[/^[a-z]{2}\-[a-z]+\-\d+$/]  $aws_region = $::rancher_infra::ci::scheduled_master_branch::provision::aws_region,
  Pattern[/^[a-e]$/]                  $aws_zone = $::rancher_infra::ci::scheduled_master_branch::provision::aws_zone,
  Hash[String, String]                $tags = $::rancher_infra::ci::scheduled_master_branch::provision::tags,
  ) {

  $cidr_block = '172.16.100.0/24'

  ec2_vpc { 'ci-scheduled-master-vpc':
    ensure => present,
    cidr_block => $cidr_block,
    instance_tenancy => 'default',
    region => $aws_region,
    tags => $tags,
  } ->

  ec2_vpc_subnet { 'ci-scheduled-master-subnet':
    ensure => present,
    vpc => 'ci-scheduled-master-vpc',
    region => $aws_region,
    availability_zone => "${aws_region}${aws_zone}",
    cidr_block => $cidr_block,
    tags => $tags,
  } ->

  ec2_securitygroup { 'ci-scheduled-master-sg':
    ensure => present,
    description => 'SG for Rancher HA demo',
    region => $aws_region,
    ingress => [
      { security_group => 'ci-scheduled-master-sg' },
      { protocol => 'tcp', port => '22',   cidr => '0.0.0.0/0' },
      { protocol => 'tcp', port => '8080', cidr => '0.0.0.0/0' },
      { protocol => 'icmp', cidr => '0.0.0.0/0' },
    ],
    vpc => 'ci-scheduled-master-vpc',
    tags => $tags,
  } ->

  ec2_vpc_internet_gateway { 'ci-scheduled-master-vpc-gateway':
    ensure => present,
    region => $aws_region,
    vpc => 'ci-scheduled-master-vpc',
  } ->

  ec2_vpc_routetable { 'ci-scheduled-master-vpc-routing':
    ensure => present,
    region => $aws_region,
    vpc => 'ci-scheduled-master-vpc',
    routes => [
      {
        destination_cidr_block => $cidr_block,
        gateway => 'local',
      },
      {
        destination_cidr_block => '0.0.0.0/0',
        gateway => 'ci-scheduled-master-vpc-gateway',
      },
    ],
  }  
}

class rancher_infra::ci::scheduled_master_branch::provision::network(
  Pattern[/^[a-z]{2}\-[a-z]+\-\d+$/]  $aws_region = $::rancher_infra::ci::scheduled_master_branch::provision::aws_region,
  Pattern[/^[a-e]$/]                  $aws_zone = $::rancher_infra::ci::scheduled_master_branch::provision::aws_zone,
  Hash[String, String]                $tags = $::rancher_infra::ci::scheduled_master_branch::provision::tags,
  ) {

  $vpc_cidr_block = '172.16.0.0/16'
  $subnet_cidr_block = '172.16.100.0/24'

  ec2_vpc { 'ci-scheduled-master-vpc':
    ensure => present,
    cidr_block => $vpc_cidr_block,
    instance_tenancy => 'default',
    region => $aws_region,
    tags => $tags,
  }
    
  ec2_vpc_routetable { 'ci-scheduled-master-subnet-routing':
    ensure => present,
    region => $aws_region,
    vpc => 'ci-scheduled-master-vpc',
    routes => [
      {
        destination_cidr_block => $vpc_cidr_block,
        gateway => 'local',
      },
      {
        destination_cidr_block => '0.0.0.0/0',
        gateway => 'ci-scheduled-master-vpc-gateway',
      },
    ],
  }

  ec2_vpc_subnet { 'ci-scheduled-master-subnet':
    ensure => present,
    vpc => 'ci-scheduled-master-vpc',
    region => $aws_region,
    availability_zone => "${aws_region}${aws_zone}",
    cidr_block => $subnet_cidr_block,
    route_table => 'ci-scheduled-master-subnet-routing',
    tags => $tags,
  } ->

  ec2_securitygroup { 'ci-scheduled-master-sg':
    ensure => present,
    description => 'SG for Rancher CI nodes',
    region => $aws_region,
    ingress => [
      { security_group => 'ci-scheduled-master-sg' },
      { protocol => 'tcp', port => '22', cidr => '104.197.15.75/32' }, # jenkins-poc.rancher.io
      { protocol => 'tcp', port => '8080', cidr => '104.197.15.75/32' }, # jenkins-poc.rancher.io
      { protocol => 'tcp', port => '8081', cidr => '104.197.15.75/32' }, # jenkins-poc.rancher.io
      { protocol => 'tcp', port => '8082', cidr => '104.197.15.75/32' }, # jenkins-poc.rancher.io
      { protocol => 'tcp', port => '8083', cidr => '104.197.15.75/32' }, # jenkins-poc.rancher.io
      { protocol => 'tcp', port => '8084', cidr => '104.197.15.75/32' }, # jenkins-poc.rancher.io
      { protocol => 'tcp', port => '8085', cidr => '104.197.15.75/32' }, # jenkins-poc.rancher.io
      { protocol => 'tcp', port => '8086', cidr => '104.197.15.75/32' }, # jenkins-poc.rancher.io
      { protocol => 'tcp', port => '8087', cidr => '104.197.15.75/32' }, # jenkins-poc.rancher.io
      { protocol => 'tcp', port => '8088', cidr => '104.197.15.75/32' }, # jenkins-poc.rancher.io
      { protocol => 'tcp', port => '8089', cidr => '104.197.15.75/32' }, # jenkins-poc.rancher.io
      { protocol => 'tcp', port => '8090', cidr => '104.197.15.75/32' }, # jenkins-poc.rancher.io
      { protocol => 'tcp', port => '22', cidr => '50.255.37.17/32' }, # Cupertino office
      { protocol => 'tcp', port => '8080', cidr => '50.255.37.17/32' }, # Cupertino office
      { protocol => 'tcp', port => '8081', cidr => '50.255.37.17/32' }, # Cupertino office
      { protocol => 'tcp', port => '8082', cidr => '50.255.37.17/32' }, # Cupertino office
      { protocol => 'tcp', port => '8083', cidr => '50.255.37.17/32' }, # Cupertino office
      { protocol => 'tcp', port => '8084', cidr => '50.255.37.17/32' }, # Cupertino office
      { protocol => 'tcp', port => '8085', cidr => '50.255.37.17/32' }, # Cupertino office
      { protocol => 'tcp', port => '8086', cidr => '50.255.37.17/32' }, # Cupertino office
      { protocol => 'tcp', port => '8087', cidr => '50.255.37.17/32' }, # Cupertino office
      { protocol => 'tcp', port => '8088', cidr => '50.255.37.17/32' }, # Cupertino office
      { protocol => 'tcp', port => '8089', cidr => '50.255.37.17/32' }, # Cupertino office
      { protocol => 'tcp', port => '8090', cidr => '50.255.37.17/32' }, # Cupertino office
      { protocol => 'tcp', port => '22', cidr => '98.191.181.70/32' }, # AZ office
      { protocol => 'tcp', port => '8080', cidr => '98.191.181.70/32' }, # AZ office
      { protocol => 'tcp', port => '8081', cidr => '98.191.181.70/32' }, # AZ office
      { protocol => 'tcp', port => '8082', cidr => '98.191.181.70/32' }, # AZ office
      { protocol => 'tcp', port => '8083', cidr => '98.191.181.70/32' }, # AZ office
      { protocol => 'tcp', port => '8084', cidr => '98.191.181.70/32' }, # AZ office
      { protocol => 'tcp', port => '8085', cidr => '98.191.181.70/32' }, # AZ office
      { protocol => 'tcp', port => '8086', cidr => '98.191.181.70/32' }, # AZ office
      { protocol => 'tcp', port => '8087', cidr => '98.191.181.70/32' }, # AZ office
      { protocol => 'tcp', port => '8088', cidr => '98.191.181.70/32' }, # AZ office
      { protocol => 'tcp', port => '8089', cidr => '98.191.181.70/32' }, # AZ office
      { protocol => 'tcp', port => '8090', cidr => '98.191.181.70/32' }, # AZ office
      { protocol => 'tcp', port => '22',   cidr => '0.0.0.0/0' },
      { protocol => 'icmp', cidr => '0.0.0.0/0' },
    ],
    vpc => 'ci-scheduled-master-vpc',
    tags => $tags,
  }

  ec2_vpc_internet_gateway { 'ci-scheduled-master-vpc-gateway':
    ensure => present,
    region => $aws_region,
    vpc => 'ci-scheduled-master-vpc',
  }
}

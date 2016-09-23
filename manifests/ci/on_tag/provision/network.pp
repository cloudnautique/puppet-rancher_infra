class rancher_infra::ci::on_tag::provision::network(
  Pattern[/^.+$/]                     $uuid,
  Pattern[/^[a-z]{2}\-[a-z]+\-\d+$/]  $aws_region = $::rancher_infra::ci::on_tag::provision::aws_region,
  Pattern[/^[a-e]$/]                  $aws_zone = $::rancher_infra::ci::on_tag::provision::aws_zone,
  Hash[String, String]                $tags = $::rancher_infra::ci::on_tag::provision::tags,
  ) {

  $vpc_cidr_block = '172.16.0.0/16'
  $subnet_cidr_block = '172.16.100.0/24'

  ec2_vpc { 'ci-on-tag-vpc':
    ensure => present,
    cidr_block => $vpc_cidr_block,
    instance_tenancy => 'default',
    region => $aws_region,
    tags => $tags,
  }
    
  ec2_vpc_routetable { 'ci-on-tag-subnet-routing':
    ensure => present,
    region => $aws_region,
    vpc => 'ci-on-tag-vpc',
    routes => [
      {
        destination_cidr_block => $vpc_cidr_block,
        gateway => 'local',
      },
      {
        destination_cidr_block => '0.0.0.0/0',
        gateway => 'ci-on-tag-vpc-gateway',
      },
    ],
  }

  ec2_vpc_subnet { 'ci-on-tag-subnet':
    ensure => present,
    vpc => 'ci-on-tag-vpc',
    region => $aws_region,
    availability_zone => "${aws_region}${aws_zone}",
    cidr_block => $subnet_cidr_block,
    route_table => 'ci-on-tag-subnet-routing',
    tags => $tags,
  } ->

  ec2_securitygroup { 'ci-on-tag-sg':
    ensure => present,
    description => 'SG for Rancher CI nodes',
    region => $aws_region,
    ingress => [
      { security_group => 'ci-on-tag-sg' },
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
    vpc => 'ci-on-tag-vpc',
    tags => $tags,
  }

  ec2_vpc_internet_gateway { 'ci-on-tag-vpc-gateway':
    ensure => present,
    region => $aws_region,
    vpc => 'ci-on-tag-vpc',
  }
}

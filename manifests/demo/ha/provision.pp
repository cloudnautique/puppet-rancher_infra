class rancher_infra::demo::ha::provision(
  Pattern[/^[a-z]{2}\-[a-z]+\-\d+$/]  $aws_region,
  Pattern[/^[a-e]$/]                  $aws_zone,
  Pattern[/^.+$/]                     $mysql_root_password,
  Pattern[/^.+$/]                     $rancher_version,
  Pattern[/^.+$/]                     $ssh_key, # this must already exist!
  ) {

  $tags = { 'is_demo' => 'true', 'demo' => 'HA', 'owner' => $::id }
  $cidr_block = '172.16.100.0/24'

  ec2_vpc { 'ha-demo-vpc':
    ensure => present,
    cidr_block => $cidr_block,
    instance_tenancy => 'default',
    region => $aws_region,
    tags => $tags,
  } ->

  ec2_vpc_subnet { 'ha-demo-subnet':
    ensure => present,
    vpc => 'ha-demo-vpc',
    region => $aws_region,
    availability_zone => "${aws_region}${aws_zone}",
    cidr_block => $cidr_block,
    tags => $tags,
  } ->

  ec2_securitygroup { 'ha-demo-sg':
    ensure => present,
    description => 'SG for Rancher HA demo',
    region => $aws_region,
    ingress => [
      { security_group => 'ha-demo-sg' },
      { protocol => 'tcp', port => '22',   cidr => '0.0.0.0/0' },
      { protocol => 'tcp', port => '8080', cidr => '0.0.0.0/0' },
      { protocol => 'icmp', cidr => '0.0.0.0/0' },
    ],
    vpc => 'ha-demo-vpc',
    tags => $tags,
  } ->

  ec2_vpc_internet_gateway { 'ha-demo-vpc-gateway':
    ensure => present,
    region => $aws_region,
    vpc => 'ha-demo-vpc',
  } ->

  ec2_vpc_routetable { 'ha-demo-vpc-routing':
    ensure => present,
    region => $aws_region,
    vpc => 'ha-demo-vpc',
    routes => [
      {
        destination_cidr_block => $cidr_block,
        gateway => 'local',
      },
      {
        destination_cidr_block => '0.0.0.0/0',
        gateway => 'ha-demo-vpc-gateway',
      },
    ],
  }
  
  rds_instance { 'ha-demo-rds':
    ensure => present,
    db_name => 'rancherha',
    region => $aws_region,
    availability_zone => "${aws_region}${aws_zone}",
    engine => 'mysql',
    master_username => 'rancherha',
    master_user_password => $mysql_root_password,
    db_instance_class => 'db.m4.large',
    allocated_storage => '10',
  }

  # spin the HA rancher server nodes
  ec2_instance { ['ha-demo-rancher0', 'ha-demo-rancher1', 'ha-demo-rancher2']:
    ensure        => present,
    region        => $aws_region,
    availability_zone => "${aws_region}${aws_zone}",
    image_id      => 'ami-e59bda85',
    instance_type => 'm3.medium',
    associate_public_ip_address => true,
    subnet => 'ha-demo-subnet',
    security_groups => [ 'ha-demo-sg' ],
    key_name => $ssh_key,
    user_data => template("${module_name}/demo/ha/rancher-server.sh"),
    tags => $tags,
  }

  # spin a single compute node
  ec2_instance { 'ha-demo-compute0':
    ensure        => present,
    region        => $aws_region,
    availability_zone => "${aws_region}${aws_zone}",
    image_id      => 'ami-e59bda85',
    instance_type => 'm3.medium',
    associate_public_ip_address => true,
    subnet => 'ha-demo-subnet',
    security_groups => [ 'ha-demo-sg' ],
    key_name => $ssh_key,
    user_data => template("${module_name}/demo/ha/rancher-compute.sh"),
    tags => $tags,
  }
  
  # create ELB
#  elb_loadbalancer { 'ha-demo-elb':
#    ensure => present,
#    region => $aws_region,
#    availability_zones => [ "${aws_region}${aws_zone}" ],
#    tags => $tags,
#  }
  
}

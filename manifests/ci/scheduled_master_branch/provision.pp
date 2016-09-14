class rancher_infra::ci::scheduled_master_branch::provision(
  Pattern[/^[a-z]{2}\-[a-z]+\-\d+$/]  $aws_region,
  Pattern[/^[a-e]$/]                  $aws_zone,
  Pattern[/^.+$/]                     $mysql_root_password,
  Pattern[/^.+$/]                     $rancher_version,
  Pattern[/^.+$/]                     $ssh_key, # this must already exist!
  ) {

  $tags = { 'is_demo' => 'true', 'demo' => 'HA', 'owner' => $::id }
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
  
  rds_instance { 'ci-scheduled-master-rds':
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
  ec2_instance { ['ci-scheduled-master-rancher0', 'ci-scheduled-master-rancher1', 'ci-scheduled-master-rancher2']:
    ensure        => present,
    region        => $aws_region,
    availability_zone => "${aws_region}${aws_zone}",
    image_id      => 'ami-e59bda85',
    instance_type => 'm3.medium',
    associate_public_ip_address => true,
    subnet => 'ci-scheduled-master-subnet',
    security_groups => [ 'ci-scheduled-master-sg' ],
    key_name => $ssh_key,
    user_data => template("${module_name}/demo/ha/rancher-server.sh"),
    tags => $tags,
  }

  # spin a single compute node
  ec2_instance { 'ci-scheduled-master-compute0':
    ensure        => present,
    region        => $aws_region,
    availability_zone => "${aws_region}${aws_zone}",
    image_id      => 'ami-e59bda85',
    instance_type => 'm3.medium',
    associate_public_ip_address => true,
    subnet => 'ci-scheduled-master-subnet',
    security_groups => [ 'ci-scheduled-master-sg' ],
    key_name => $ssh_key,
    user_data => template("${module_name}/demo/ha/rancher-compute.sh"),
    tags => $tags,
  }
  
  # create ELB
#  elb_loadbalancer { 'ci-scheduled-master-elb':
#    ensure => present,
#    region => $aws_region,
#    availability_zones => [ "${aws_region}${aws_zone}" ],
#    tags => $tags,
#  }
  
}

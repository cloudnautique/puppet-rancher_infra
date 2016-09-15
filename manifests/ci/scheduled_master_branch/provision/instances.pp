class rancher_infra::ci::scheduled_master_branch::provision::instances(
  Pattern[/^[a-z]{2}\-[a-z]+\-\d+$/]  $aws_region = $::rancher_infra::ci::scheduled_master_branch::provision::aws_region,
  Pattern[/^[a-e]$/]                  $aws_zone = $::rancher_infra::ci::scheduled_master_branch::provision::aws_zone,
  Pattern[/^ami\-.+$/]                $default_ami = $::rancher_infra::ci::scheduled_master_branch::provision::default_ami,
  Pattern[/^.+$/]                     $ssh_key = $::rancher_infra::ci::scheduled_master_branch::provision::ssh_key,
  Hash[String, String]                $tags = $::rancher_infra::ci::scheduled_master_branch::provision::tags,
  ) {

  # spin the rancher server node
  ec2_instance { 'ci-scheduled-master-branch0':
    ensure        => present,
    region        => $aws_region,
    availability_zone => "${aws_region}${aws_zone}",
    image_id      => 'ami-20be7540',
    instance_type => 'm4.large',
    associate_public_ip_address => true,
    subnet => 'ci-scheduled-master-subnet',
    security_groups => [ 'ci-scheduled-master-sg' ],
    key_name => $ssh_key,
    user_data => template("${module_name}/ci/scheduled_master_branch/rancher-server.sh.erb"),
    tags => $tags,
    instance_initiated_shutdown_behavior => 'terminate', # this is a hack
  }
#  } ->

  # spin ubuntu 14.04 agents
 #  ec2_instance { ['ci-scheduled-ubuntu-agent0', 'ci-scheduled-ubuntu-agent1', 'ci-scheduled-ubuntu-agent2']:
 #    ensure        => present,
 #    region        => $aws_region,
 #    availability_zone => "${aws_region}${aws_zone}",
 #    image_id      => 'ami-fd74379d',
 #    instance_type => 'm3.medium',
 #    associate_public_ip_address => true,
 #    subnet => 'ci-scheduled-master-subnet',
 #    security_groups => [ 'ci-scheduled-master-sg' ],
 #    key_name => $ssh_key,
 # #   user_data => template("${module_name}/demo/ci/rancher-agent.sh"),
 #    tags => $tags,
 #  }

  # spin ubuntu 16.04 agents
  # spin centos 6 agents
  # spin centos 7 agents  
}

class rancher_infra::ci::scheduled_master_branch::provision::instances_agents(
  Pattern[/^[a-z]{2}\-[a-z]+\-\d+$/]  $aws_region = $::rancher_infra::ci::scheduled_master_branch::provision::aws_region,
  Pattern[/^[a-e]$/]                  $aws_zone = $::rancher_infra::ci::scheduled_master_branch::provision::aws_zone,
  Pattern[/^ami\-.+$/]                $default_ami = $::rancher_infra::ci::scheduled_master_branch::provision::default_ami,
  Pattern[/^.+$/]                     $ssh_key = $::rancher_infra::ci::scheduled_master_branch::provision::ssh_key,
  Hash[String, String]                $tags = $::rancher_infra::ci::scheduled_master_branch::provision::tags,
  ) {

  Ec2_instance {
    ensure        => present,
    region        => $aws_region,
    availability_zone => "${aws_region}${aws_zone}",
    image_id      => $default_ami,
    instance_type => 't2.medium',
    subnet => 'ci-scheduled-master-subnet',
    security_groups => [ 'ci-scheduled-master-sg' ],
    key_name => $ssh_key,
    tags => $tags,
    associate_public_ip_address => true,
    instance_initiated_shutdown_behavior => 'terminate',# this is a hack
  }

  # spin the root rancher/server's agent
  ec2_instance { 'ci-scheduled-master-server0-agent0':
    image_id      => 'ami-a9b972c9',
    instance_type => 'r3.xlarge',
    user_data => template("${module_name}/ci/scheduled_master_branch/agent/ubuntu.sh.erb"),
  }

  # Ubuntu 14.04 agent nodes
  ec2_instance { [ 'ci-scheduled-master-ubuntu-1404-agent0',
                   'ci-scheduled-master-ubuntu-1404-agent1',
                   'ci-scheduled-master-ubuntu-1404-agent2' ]:
    image_id      => 'ami-20be7540',
    user_data => template("${module_name}/ci/scheduled_master_branch/agent/ubuntu.sh.erb"),
  }

  # Ubuntu 16.04 agent nodes
  ec2_instance { [ 'ci-scheduled-master-ubuntu-1604-agent0',
                   'ci-scheduled-master-ubuntu-1604-agent1',
                   'ci-scheduled-master-ubuntu-1604-agent2' ]:
    image_id      => 'ami-746aba14',
    user_data => template("${module_name}/ci/scheduled_master_branch/agent/ubuntu.sh.erb"),
  }

  # CentOS7 agent nodes
  ec2_instance { [ 'ci-scheduled-master-centos-7-agent0',
                   'ci-scheduled-master-centos-7-agent1',
                   'ci-scheduled-master-centos-7-agent2' ]:
    image_id      => 'ami-d2c924b2',
    user_data => template("${module_name}/ci/scheduled_master_branch/agent/redhat.sh.erb"),
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

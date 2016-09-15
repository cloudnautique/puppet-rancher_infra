class rancher_infra::ci::scheduled_master_branch(
  Pattern[/^[a-z]{2}\-[a-z]+\-\d+$/]            $aws_region          = $::rancher_infra::aws_region,
  Pattern[/^[a-e]$/]                            $aws_zone            = $::rancher_infra::aws_zone,
  Pattern[/^ami\-.+$/]                          $default_ami         = $::rancher_infra::default_ami,
  Optional[Pattern[/^.+$/]]                     $ssh_key             = $::rancher_infra::default_ssh_key,
  Optional[Enum['present', 'absent', 'agents']] $ensure              = 'present',
  ) {

  require ::rancher_infra::ci

  case $ensure {
    'present','agents': {
      class { '::rancher_infra::ci::scheduled_master_branch::provision':
        ensure => $ensure,
        aws_region => $aws_region,
        aws_zone => $aws_zone,
        default_ami => $default_ami,
        ssh_key => $ssh_key,
        tags => { 'is_ci' => 'true', 'ci' => 'scheduled_master_branch', 'owner' => $::id },
      }
    }

    'absent': {
      class { '::rancher_infra::ci::scheduled_master_branch::deprovision':
        aws_region => $aws_region,
        aws_zone => $aws_zone,
      }
    }
    
    default: { fail("Invalid value \'${ensure}\' passed for 'ensure'!") }
  }
}

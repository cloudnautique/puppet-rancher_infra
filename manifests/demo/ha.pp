class rancher_infra::demo::ha(
  Pattern[/^[a-z]{2}\-[a-z]+\-\d+$/]  $aws_region          = $::rancher_infra::aws_region,
  Pattern[/^[a-e]$/]                  $aws_zone            = $::rancher_infra::aws_zone,
  Pattern[/^.+$/]                     $mysql_root_password = $::rancher_infra::default_mysql_root_password,
  Optional[Pattern[/^.+$/]]           $ssh_key             = $::rancher_infra::default_ssh_key,
  Optional[Enum['present', 'absent']] $ensure              = 'present',
  Optional[Pattern[/^.+$/]]           $rancher_version     = 'enterprise',
  ) {

  require ::rancher_infra::demo

  case $ensure {
    'present': {
      class { '::rancher_infra::demo::ha::provision':
        aws_region => $aws_region,
        aws_zone => $aws_zone,
        mysql_root_password => $mysql_root_password,
        rancher_version => $rancher_version,
        ssh_key => $ssh_key,
      }
    }

    'absent': {
      class { '::rancher_infra::demo::ha::deprovision':
        aws_region => $aws_region,
        aws_zone => $aws_zone,
      }
    }
    
    default: { fail("Invalid value \'${ensure}\' passed for 'ensure'!") }
  }
}

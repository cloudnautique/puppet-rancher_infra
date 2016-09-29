class rancher_infra::ci::validation_tests(
  Pattern[/^[a-z]{2}\-[a-z]+\-\d+$/]            $aws_region          = $::rancher_infra::aws_region,
  Pattern[/^[a-e]$/]                            $aws_zone            = $::rancher_infra::aws_zone,
  Pattern[/^.+$/]                               $ssh_key             = $::rancher_infra::default_ssh_key,
  Optional[Enum['present', 'absent', 'agents']] $ensure              = 'present',
  ) {

  require ::rancher_infra::ci

  case $ensure {
    'present','agents': {
      class { '::rancher_infra::ci::validation_tests::provision':
        ensure => $ensure,
        aws_region => $aws_region,
        aws_zone => $aws_zone,
        ssh_key => $ssh_key,
        tags => { 'is_ci' => 'true', 'ci' => 'validation_tests', 'owner' => $::id, },
      }
    }

    'absent': {
      class { '::rancher_infra::ci::validation_tests::deprovision': aws_region => $aws_region, }
    }
    
    default: { fail("Invalid value \'${ensure}\' passed for 'ensure'!") }
  }
}

class rancher_infra(
  Optional[Pattern[/^[a-z]{2}\-[a-z]+\-\d+$/]] $aws_region,
  Optional[Pattern[/^[a-e]$/]]                 $aws_zone,
  Optional[Pattern[/^.+$/]]                    $default_mysql_root_password,
  Optional[Pattern[/^.+$/]]                    $default_ssh_key,
  ) {
}

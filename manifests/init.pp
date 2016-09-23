class rancher_infra(
  Pattern[/^.+$/]                     $default_ssh_key,
  Pattern[/^[a-z]{2}\-[a-z]+\-\d+$/]  $aws_region = 'us-west-2',
  Pattern[/^[a-e]$/]                  $aws_zone = 'a',
  ) {
}

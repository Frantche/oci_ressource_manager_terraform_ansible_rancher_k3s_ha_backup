---
ansible_user: "${ssh_username}"
systemd_dir: "/etc/systemd/system"
master_ip: "${loadbalancer_master_ip}"
extra_server_args: ""
extra_agent_args: ""

k3s_token: "${k3s_token}"

rancher_hostname: "${rancher_hostname}"
acme_issue_email: "${email}"
acme_server_url: "${acme_server_url}"
rancher_backup_filename: "${rancher_backup_filename}"
rancher_backup_accessKey: "${rancher_backup_accessKey}"
rancher_backup_secretKey: "${rancher_backup_secretKey}"
rancher_backup_bucket_name: "${rancher_backup_bucket_name}"
rancher_backup_region: "${rancher_backup_region}"
rancher_backup_folder: "${rancher_backup_folder}"
rancher_backup_endpoint: "${rancher_backup_endpoint}"
rancher_backup_endpointCA: "${rancher_backup_endpointCA}"
rancher_backup_encryption_config_secretbox: "${rancher_backup_encryption_config_secretbox}"
rancher_backup_schedule: "${rancher_backup_schedule}"
rancher_backup_retentioncount: "${rancher_backup_retentioncount}"

k3s_github_release_name: "${k3s_version}"
helm_rancher_chart_version: "${rancher_version}"
helm_rancher_backup_chart_version: "${rancher_backup_version}"

helm_rancher_values:
  hostname: "{{ rancher_hostname }}"
  ingress.tls.source: letsEncrypt
  letsEncrypt.ingress.class: nginx
  letsEncrypt.email: "{{ acme_issue_email }} "
  replicas: "{{ groups['agent'] | length }}"
Host *
    StrictHostKeyChecking no
    AddKeysToAgent yes
    IdentityFile ${private_key_path}
    UserKnownHostsFile=/dev/null
    ServerAliveInterval 30

Host oci_bastion
    StrictHostKeyChecking no
    User ${bastion_username}
    HostName ${bastion_hostname}
    AddKeysToAgent yes
    IdentityFile ${private_key_path}
    ForwardAgent yes

Host first_master
    StrictHostKeyChecking no
    AddKeysToAgent yes
    User ${destination_ssh_user}
    HostName ${first_master_private_ip}
    IdentityFile ${private_key_path}
    Port 22
    ProxyJump oci_bastion
    LocalForward 2242 localhost:22


%{ for master in master_private_ip ~}
Host ${master}
    StrictHostKeyChecking no
    AddKeysToAgent yes
    User ${destination_ssh_user}
    HostName ${master}
    IdentityFile ${private_key_path}
    ProxyJump first_master
%{ endfor ~}

%{ for agent in agent_private_ip ~}
Host ${agent}
    StrictHostKeyChecking no
    AddKeysToAgent yes
    User ${destination_ssh_user}
    HostName ${agent}
    IdentityFile ${private_key_path}
    ProxyJump first_master
%{ endfor ~}

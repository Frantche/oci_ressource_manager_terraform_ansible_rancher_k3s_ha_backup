Host *
    StrictHostKeyChecking no
    AddKeysToAgent yes
    IdentityFile ${private_key_path}
    UserKnownHostsFile=/dev/null
    ServerAliveInterval 30
    HostkeyAlgorithms ssh-rsa,ssh-ed25519
    PubkeyAcceptedKeyTypes ssh-ed25519,ssh-rsa

Host oci_bastion
    User ${bastion_username}
    HostName ${bastion_hostname}
    ForwardAgent yes

Host first_master
    User ${destination_ssh_user}
    HostName ${first_master_private_ip}
    Port 22
    ProxyJump oci_bastion
    LocalForward 2242 localhost:22


%{ for master in master_private_ip ~}
Host ${master}
    User ${destination_ssh_user}
    HostName ${master}
    ProxyJump first_master
%{ endfor ~}

%{ for agent in agent_private_ip ~}
Host ${agent}
    User ${destination_ssh_user}
    HostName ${agent}
    ProxyJump first_master
%{ endfor ~}

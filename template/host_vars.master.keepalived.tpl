keepalived_role: %{ if index == 0 }MASTER%{ else }BACKUP%{ endif }
keepalived_priority: ${count - index}
keepalived_router_id: 51
vnic_id: ${vnic_id}

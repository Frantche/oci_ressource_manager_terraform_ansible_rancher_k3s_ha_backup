haproxy_backend_servers:
%{ for master in masters ~}
  - name: ${master}
    address: ${master}
%{ endfor ~}
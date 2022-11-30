---
all:
    children:
        k3s_cluster:
            children:
                master:
                    hosts:
%{ for master in masters ~}
                        ${ master }: {}
%{ endfor ~}
                agent:
                    hosts:
%{ for agent in agents ~}
                        ${ agent }: {}
%{ endfor ~}


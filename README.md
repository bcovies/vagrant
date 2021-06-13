# vagrant_ansible_deploy

## Este projeto foi concebido como um ambiente de desenvolvimento para meus estudos em devops motivados pelo estágio no BNDES.

Este repositório conta com a seguinte estrutura:

```
 ---------------
| 192.168.1.200 |
|    Máquina    |
|     Host      |
 ---------------
        |
        |
        |
        |
 ---------------           ----------------           --------------            ---------------           ---------------           ---------------
|  192.168.1.12 |         |  192.168.1.11 |          |  192.168.1.10 |         |  192.168.1.20 |         |  192.168.1.21 |         |  192.168.1.22 |
|    Máquina    | ------- |    Máquina    | -------- |    Máquina    | ------- |    Máquina    | ------- |    Máquina    | ------- |    Máquina    |
|    Rundeck    |         |    GitLab     |          |    Jenkins    |         |   DockerMgr   |         |   Dockerwrk1  |         |   Dockerwrk2  |
|    RAM: 2048  |         |    RAM: 4096  |          |    RAM: 4096  |         |    RAM: 1024  |         |    RAM: 1024  |         |    RAM: 1024  |
|    CPU: 1     |         |    CPU: 1     |          |    CPU: 1     |         |    CPU: 1     |         |    CPU: 1     |         |    CPU: 1     |
|  OS: Centos 8 |         |  OS: Centos 8 |          |  OS: Centos 8 |         |OS:Ubuntu 20.04|         |OS:Ubuntu 20.04|         |OS:Ubuntu 20.04| 
 ---------------           ---------------            ---------------           ---------------           ---------------           --------------- 
```

Tal infra conta com DNS e Proxy Reverso instalado com bases neste repositório: https://github.com/bcovies/ansible 


## Atenção!!

Preste atenção nos itens abaixo, há modificações que podem travar o seu instalador. Para evitar isto, separei alguns pontos que ou irão faltar ou alterar de acordo com seu ambiente (IP,DNS,Usuário etc)

SSH: Colocar authorized_keys, id_rsa, id_rsa.pub em

    vagrant_ansible_deploy/ansible/centos/roles/user/files/.ssh


Hosts:

Cuidado, pois, não está sendo referenciado o IP e sim o DNS, altere, se necessário em:

    vagrant_ansible_deploy/ansible/ubuntu/hosts


## Ubuntu:
Usuário: ubuntu

 DNS:
  
    vagrant_ansible_deploy/ansible/ubuntu/roles/dns/files/netplan.yaml
    
Altere pelo seu IP

 ```
    gateway4: 192.168.1.254
    nameservers:
        addresses: [192.168.1.200, 192.168.1.254]
 ```   
 
 OBS: ``` Docker faz bind na porta 2735 ```
  
  Path: 
  
    vagrant_ansible_deploy/ansible/ubuntu/roles/docker/files/override.conf

## Centos

Usuário: centos

Altere pelo seu IP

 ```
   vagrant_ansible_deploy/ansible/centos/roles/common/tasks/main.yml

   # DNS
    - name: "[WORKAROUND (CENTOS 8)]: Altera o DNS da máquina"
      become: true
      shell: echo "nameserver 192.168.1.200" > /etc/resolv.conf; echo "nameserver 192.168.1.254" >> /etc/resolv.conf;  chattr +i /etc/resolv.conf;

 ```   
 

Hosts:

Cuidado, pois, não está sendo referenciado o IP e sim o DNS, altere, se necessário em:

    vagrant_ansible_deploy/ansible/centos/hosts

Gitlab URL: 
```
vagrant_ansible_deploy/ansible/centos/roles/gitlab/tasks/main.yml

- name: "Instala gitlab"
  become: true
  shell: EXTERNAL_URL="http://gitlab.vm.dns.net" dnf install -y gitlab-ee
```

Rundeck URL:

```
vagrant_ansible_deploy/ansible/centos/roles/rundeck/tasks/main.yml

- name: "Adiciona o hostname no arquivo"
  become: true
  shell: echo "grails.serverURL=http://rundeck.dns.br" >> /etc/rundeck/rundeck-config.properties

```



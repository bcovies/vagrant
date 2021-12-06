#!/bin/bash

vagrant up

sleep 10


cd ./ansible

ansible-playbook -i ./hosts ./docker_mgr.yml
ansible-playbook -i ./hosts ./docker_workers.yml
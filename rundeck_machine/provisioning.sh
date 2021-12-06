#!/bin/bash

vagrant up

sleep 10


cd ./ansible

ansible-playbook -i ./hosts ./provisioning.yml.yml
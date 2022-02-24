#!/bin/bash

PROJECTS_TEMPLATES=( "rundeck" "jenkins" "dockermgr" "dockerwkr1" )
CONFD_BIN_FILE=confd-0.16.0-linux-amd64
PATH_TMP_FILES=/tmp/confd/vagrant

get_local_pwd(){
    CURRENT_PATH=$(pwd)
    echo "----------------------------------------------------------------------------"
    echo "Your current path is: ${CURRENT_PATH}"
}

create_templates_path_tmp(){
    echo "----------------------------------------------------------------------------"
    echo "Creating all /tmp/ folders to confd templates..."
    for local_folder_name in ${PROJECTS_TEMPLATES[@]}; do
        mkdir -p ${PATH_TMP_FILES}/${local_folder_name}/files
        if [[ -d ${PATH_TMP_FILES}/${local_folder_name}/files ]]; then
            echo "----------------------------------------------------------------------------"
            echo "OK ${PATH_TMP_FILES}/${local_folder_name}/files"
        else
            echo "----------------------------------------------------------------------------"
            echo "ERROR: cloud not create ${PATH_TMP_FILES}/${local_folder_name}/files"
            exit 1
        fi
    done
}

create_templates_confd(){
    if [[ ! -z ${CURRENT_PATH} ]]; then
        chmod +x ${CURRENT_PATH}/${CONFD_BIN_FILE}
        echo "----------------------------------------------------------------------------"
        for local_folder_name in ${PROJECTS_TEMPLATES[@]}; do
            echo "CURRENT TEMPLATE: ${local_folder_name}"
            echo
            env $(cat .env | grep ^[A-Z] | xargs) \
                ${CURRENT_PATH}/${CONFD_BIN_FILE} -onetime \
                    -confdir ${CURRENT_PATH}/templates/${local_folder_name} -backend env
            echo "----------------------------------------------------------------------------"
        done
    else
        echo "----------------------------------------------------------------------------"
        echo "ERROR: Var CURRENT_PATH is empty, checkout this script!"
    fi
}


create_local_foldes(){
    for local_folder_name in ${PROJECTS_TEMPLATES[@]}; do
            echo "CREATING FOLDER: ${CURRENT_PATH}/${local_folder_name}"
            mkdir -p ${CURRENT_PATH}/${local_folder_name}
    done
    echo "----------------------------------------------------------------------------"
}


copy_files_tmp_folder(){
    for local_folder_name in ${PROJECTS_TEMPLATES[@]}; do
        echo "COPYING CURRENT TEMPLATE: ${local_folder_name}"
        echo
        echo "${PATH_TMP_FILES}/${local_folder_name} --> ${CURRENT_PATH}/${local_folder_name}"
        cp -a ${PATH_TMP_FILES}/${local_folder_name}/* ${CURRENT_PATH}/${local_folder_name}
        echo "----------------------------------------------------------------------------"
    done
}


init(){
    create_templates_path_tmp
    get_local_pwd
    create_templates_confd
    create_local_foldes
    copy_files_tmp_folder
}

init
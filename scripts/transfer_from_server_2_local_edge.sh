#!/bin/bash

source <(grep = master_config.ini)

# Getting current folder
BASEDIR=$(dirname $0)

echo ""
echo "01 - Running transfer_from_server_2_local_edge.sh"
echo "=================================================="

# donwload from server
echo ""

TARGET_RAW_DIR="${BASE_DIR}${LOCAL_DIR_RAW}"

echo ""
echo "Moving to ${TARGET_RAW_DIR}"

cd $TARGET_RAW_DIR

for FILE in "${REMOTE_FILES[@]}"
do
    # surce
    CURRENT_SOURCE="${SOURCE_REMOTE_BASE}/${FILE}"
    
    # target
    echo "Downloading ${CURRENT_SOURCE}"
    curl -O $CURRENT_SOURCE

done

ls -l 

cd $BASEDIR
echo "Now in ${BASEDIR}"
#!/bin/bash

source <(grep = master_config.ini)

# Getting current folder
BASEDIR=$(dirname $0)

echo ""
echo "03 - move_from_raw_2_hdfs_raw.sh"
echo "================================"


for FILE in "${REMOTE_FILES[@]}"
do
    TABLE_NAME=$(cut -d'.' -f1 <<< "$FILE" | tr '[:upper:]' '[:lower:]')
    FILENAME_LOWER=$(tr '[:upper:]' '[:lower:]' <<< "$FILE") 

    echo ""
    echo "Creating folders in datalake [${TABLE_NAME}]"
    docker exec ${DOCKER_HDFS_ID} hdfs dfs -mkdir -p ${HDFS_DIR_RAW}/${TABLE_NAME}
    docker exec ${DOCKER_HDFS_ID} hdfs dfs -mkdir -p ${HDFS_DIR_GOLD}/${TABLE_NAME}

    echo ""
    echo "Granting permissions on datalake for [${TABLE_NAME}]"
    docker exec ${DOCKER_HDFS_ID} hdfs dfs -chmod 777 ${HDFS_DIR_RAW}/${TABLE_NAME}
    docker exec ${DOCKER_HDFS_ID} hdfs dfs -chmod 777 ${HDFS_DIR_GOLD}/${TABLE_NAME}

    echo ""
    echo "Cleaning folder ${HDFS_DIR_RAW}/${TABLE_NAME}"
    docker exec ${DOCKER_HDFS_ID} hadoop fs -rm "${HDFS_DIR_RAW}/${TABLE_NAME}/*"

    echo ""
    echo "Copying file to HDFS (just to raw folder) [${TABLE_NAME}]"
    FROM_DIR="${HDFS_EDGE_TEMP}/${FILENAME_LOWER}"
    TO_DIR="${HDFS_DIR_RAW}/${TABLE_NAME}"
    
    echo "FROM: ${FROM_DIR}"
    echo "TO: ${TO_DIR}"
    
    docker exec ${DOCKER_HDFS_ID} hdfs dfs -copyFromLocal $FROM_DIR $TO_DIR 

    echo ""
done

docker exec datanode hadoop fs -ls /datalake/raw

echo ""
echo "Done"

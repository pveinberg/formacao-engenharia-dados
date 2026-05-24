#!/bin/bash

source <(grep = master_config.ini)

# Getting current folder
BASEDIR=$(dirname $0)

echo ""
echo "04 - create_tables_from_hdfs_raw.sh"
echo "==================================="

CURRENT_TABLE=clientes

echo "Creating [${CURRENT_TABLE}] ..."

docker exec ${DOCKER_HIVE_ID} beeline -u jdbc:hive2://localhost:10000 \
--hivevar TARGET_STAGE_DATABASE=${TARGET_STAGE_DATABASE} \
--hivevar TARGET_PRD_DATABASE=${TARGET_PRD_DATABASE} \
--hivevar HDFS_DIR=${HDFS_DIR_RAW}/${CURRENT_TABLE} \
--hivevar TARGET_TABLE=${CURRENT_TABLE} \
--hivevar CURRENT_PARTITION=${DATE} \
-f "${BASE_DIR}/${HQL_DIR}/${CURRENT_TABLE}.hql"

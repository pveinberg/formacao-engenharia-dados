#!/bin/bash

source <(grep = master_config.ini)

# Getting current folder
BASEDIR=$(dirname $0)

echo ""
echo "02 - Running move_from_edge_2_local_raw.sh"
echo "=========================================="

rm -rf "${LOCAL_EDGE_TEMP}/*"

for FILE in "${REMOTE_FILES[@]}"
do
    FILE_NAME=$(tr '[:upper:]' '[:lower:]' <<< "$FILE" )
    
    FROM_DIR="${BASE_DIR}${LOCAL_DIR_RAW}/${FILE}"
    TO_DIR="${LOCAL_EDGE_TEMP}/${FILE_NAME}"

    echo ""
    echo "Moving ${FROM_DIR} to ${TO_DIR}"

    cp $FROM_DIR $TO_DIR

done

ls -l $LOCAL_EDGE_TEMP

echo ""
echo "Done"
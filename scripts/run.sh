#!/bin/bash

clear
source <(grep = master_config.ini)

echo ""
echo "Start at ${DATETIME}"

# 01 - running transfer_from_server_2_local_edge.sh
# bash transfer_from_server_2_local_edge.sh

# 02 - move_from_edge_2_local_raw.sh
# bash move_from_edge_2_local_raw.sh

# 03 - move_from_raw_2_hdfs_raw.sh
# bash move_from_raw_2_hdfs_raw.sh

# 04 - create_tables_from_hdfs_raw.sh
bash create_tables_from_hdfs_raw.sh

echo ""
echo "End at ${DATETIME}"
exit 0

# 05
load_from_hive_2_hdfs_gold.sh
# 06
move_from_hdfs_gold_2_local_gold.sh


-- tabela clientes hive

CREATE DATABASE IF NOT EXISTS ${TARGET_STAGE_DATABASE}; 
CREATE DATABASE IF NOT EXISTS ${TARGET_PRD_DATABASE};

DROP TABLE ${TARGET_STAGE_DATABASE}.clientes;

CREATE EXTERNAL TABLE IF NOT EXISTS ${TARGET_STAGE_DATABASE}.clientes (
    address_number int,
    business_family string,
    business_unit int,
    customer string,
    customer_key int,
    customer_type string,
    division int,
    line_of_business string,
    phone string,
    region_code int,
    regional_sales_mgr string,
    search_type varchar(1)
)
COMMENT "Customers table (clientes)"
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ";"
STORED AS TEXTFILE
location  "${HDFS_DIR}"
TBLPROPERTIES ("skip.header.line.count"="1");

SELECT * FROM ${TARGET_STAGE_DATABASE}.clientes LIMIT 10;

-- Tabela clientes particionada

DROP TABLE ${TARGET_PRD_DATABASE}.clientes;

CREATE TABLE IF NOT EXISTS ${TARGET_PRD_DATABASE}.clientes (
    address_number int,
    business_family string,
    business_unit int,
    customer string,
    customer_key int,
    customer_type string,
    division int,
    line_of_business string,
    phone string,
    region_code int,
    regional_sales_mgr string,
    search_type varchar(1)
)
PARTITIONED BY (DT_FOTO STRING)
ROW FORMAT SERDE 'org.apache.hadoop.hive.ql.io.orc.OrcSerde'
STORED AS INPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.orc.OrcOutputFormat'
TBLPROPERTIES ('orc.compress'='SNAPPY');

SET hive.exec.dynamic.partition=true;
SET hive.exec.dynamic.partition.mode=nonstrict;

INSERT OVERWRITE TABLE 
    ${TARGET_PRD_DATABASE}.clientes
PARTITION(DT_FOTO)
SELECT
    address_number int,
    business_family string,
    business_unit int,
    customer string,
    customer_key int,
    customer_type string,
    division int,
    line_of_business string,
    phone string,
    region_code int,
    regional_sales_mgr string,
    search_type varchar(1),
    '${CURRENT_PARTITION}' as DT_FOTO
FROM ${TARGET_STAGE_DATABASE}.clientes;

SELECT * FROM ${TARGET_PRD_DATABASE}.clientes LIMIT 10;

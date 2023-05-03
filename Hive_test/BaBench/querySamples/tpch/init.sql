set hive.execution.engine=tez;
use tpch_100_parquet;
SET mapreduce.map.memory.mb=4096;
SET mapreduce.reduce.memory.mb=8192;
SET hive.tez.container.size=8192;

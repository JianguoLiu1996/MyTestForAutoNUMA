#!bash
# define globle veriable
OUTPATH="/home/liujianguo/MyTestForAutoNUMA/memtier_benchmark_test/Redis_Experiment_L_OFF/"
CONFIG="memtier_benchmark_L_OFF"
SERVERADDR="localhost"

# start redis by numactl interleave
function startRedisByNUMAInterleave(){
	sudo numactl --interleave=all  systemctl restart redis
	redis-server /etc/redis/redis6380.conf
}
# 准备三个进程的数据
function prepareDatabase(){
	echo "===Begin prepare Database==="
	memtier_benchmark -s $SERVERADDR -p 6379 \
		--threads=20 \
		--clients=5 \
		--requests 100000 \
		--data-size=2048 \
		--ratio=1:0 \
		--key-minimum=1 \
		--key-maximum=2621543 \
		--key-pattern P:P \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-redistests &
	memtier_benchmark -s $SERVERADDR -p 6380 \
		--threads=20 \
		--clients=5 \
		--requests 100000 \
		--data-size=2048 \
		--ratio=1:0 \
		--key-minimum=2621543 \
		--key-maximum=5243086 \
		--key-pattern P:P \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-redistests-keysize70-xxxxxxxxxxxxx- &
	memtier_benchmark -s $SERVERADDR -p 6381 \
		--threads=20 \
		--clients=5 \
		--requests 100000 \
		--data-size=2048 \
		--ratio=1:0 \
		--key-minimum=5243086 \
		--key-maximum=7864629 \
		--key-pattern P:P \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-redistests-keysize100-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- &
	wait
	echo "===Database is Ready==="
}

# 清除测试生成数据
function cleanupdatabases(){
	#clean up databases
	echo "===Begin to clean databases==="
	redis-cli -h $SERVERADDR -p 6379 flushall &
	redis-cli -h $SERVERADDR -p 6380 flushall &
	redis-cli -h $SERVERADDR -p 6381 flushall &
	wait
	echo "===Databases are cleaned==="
}

# Gauss82 高斯读写，读8写2
function Gauss82(){
	prepareDatabase # prepare databases for test

	echo "===begin test for Gauss82==="
	memtier_benchmark -s $SERVERADDR -p 6379 \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=2:8 \
		--key-minimum=1 \
		--key-maximum=2621543 \
		--key-pattern G:G \
		--key-stddev=436923 \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-redistests \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Gauss82_P1_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 6380 \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=2:8 \
		--key-minimum=2621543 \
		--key-maximum=5243086 \
		--key-pattern G:G \
		--key-stddev=436923 \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-redistests-keysize70-xxxxxxxxxxxxx-  \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Gauss82_P2_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 6381 \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=2:8 \
		--key-minimum=5243086 \
		--key-maximum=7864629 \
		--key-pattern G:G \
		--key-stddev=436923 \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-redistests-keysize100-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Gauss82_P3_$(date +"%Y%m%d%H%M%S").log" &
	wait
	echo "===Gauss82 is test end==="

	cleanupdatabases # clean up test databases
}

# Gauss110 高斯读写，读1写10
function Gauss110(){
	prepareDatabase # prepare databases for test

	echo "===begin test for Gauss110==="
	memtier_benchmark -s $SERVERADDR -p 6379 \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=10:1 \
		--key-minimum=1 \
		--key-maximum=2621543 \
		--key-pattern G:G \
		--key-stddev=436923 \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-redistests \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Gauss110_P1_$(date +"%Y%m%d%H%M%S").log" &
	
	memtier_benchmark -s $SERVERADDR -p 6380 \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=10:1 \
		--key-minimum=2621543 \
		--key-maximum=5243086 \
		--key-pattern G:G \
		--key-stddev=436923 \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-redistests-keysize70-xxxxxxxxxxxxx-  \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Gauss110_P2_$(date +"%Y%m%d%H%M%S").log" &
	
	memtier_benchmark -s $SERVERADDR -p 6381 \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=10:1 \
		--key-minimum=5243086 \
		--key-maximum=7864629 \
		--key-pattern G:G \
		--key-stddev=436923 \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-redistests-keysize100-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Gauss110_P3_$(date +"%Y%m%d%H%M%S").log" &
	wait
	echo "===Gauss110 is test end==="

	cleanupdatabases # clean up test databases
}

# Random82 随机读写，读8写2
function Random82(){
	prepareDatabase # prepare databases for test

	echo "===begin test for Random82==="
	memtier_benchmark -s $SERVERADDR -p 6379 \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=2:8 \
		--key-minimum=1 \
		--key-maximum=2621543 \
		--key-pattern R:R \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-redistests \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Random82_P1_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 6380 \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=2:8 \
		--key-minimum=2621543 \
		--key-maximum=5243086 \
		--key-pattern R:R \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-redistests-keysize70-xxxxxxxxxxxxx-  \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Random82_P2_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 6381 \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=2:8 \
		--key-minimum=5243086 \
		--key-maximum=7864629 \
		--key-pattern R:R \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-redistests-keysize100-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Random82_P3_$(date +"%Y%m%d%H%M%S").log" &
	wait
	echo "===Random82 is test end==="

	cleanupdatabases # clean up test databases
}

# Random110 随机读写，读1写10
function Random110(){
	prepareDatabase # prepare databases for test

	echo "===Begin test for Random110==="
	memtier_benchmark -s $SERVERADDR -p 6379 \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=10:1 \
		--key-minimum=1 \
		--key-maximum=2621543 \
		--key-pattern R:R \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-redistests \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Random110_P1_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 6380 \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=10:1 \
		--key-minimum=2621543 \
		--key-maximum=5243086 \
		--key-pattern R:R \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-redistests-keysize70-xxxxxxxxxxxxx-  \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Random110_P2_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 6381 \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=10:1 \
		--key-minimum=5243086 \
		--key-maximum=7864629 \
		--key-pattern R:R \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-redistests-keysize100-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Random110_P3_$(date +"%Y%m%d%H%M%S").log" &
	wait
	echo "===Random110 test is end==="

	cleanupdatabases # clean up test databases
}

# Sequential82 顺序读写，读8写2
function Sequential82(){
	prepareDatabase # prepare databases for test

	echo "===Begin test for Sequential82==="
	memtier_benchmark -s $SERVERADDR -p 6379 \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=2:8 \
		--key-minimum=1 \
		--key-maximum=2621543 \
		--key-pattern S:S \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-redistests \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Sequential82_P1_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 6380 \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=2:8 \
		--key-minimum=2621543 \
		--key-maximum=5243086 \
		--key-pattern S:S \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-redistests-keysize70-xxxxxxxxxxxxx- \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Sequential82_P2_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 6381 \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=2:8 \
		--key-minimum=5243086 \
		--key-maximum=7864629 \
		--key-pattern S:S \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-redistests-keysize100-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Sequential82_P3_$(date +"%Y%m%d%H%M%S").log" &
	wait
	echo "===Sequential82 test is end==="

	cleanupdatabases # clean up test databases
}

# Sequential110 顺序读写，读1写10
function Sequential110(){
	prepareDatabase # prepare databases for test

	echo "===Bengin test for Sequential110==="
	memtier_benchmark -s $SERVERADDR -p 6379 \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=10:1 \
		--key-minimum=1 \
		--key-maximum=2621543 \
		--key-pattern S:S \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-redistests \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Sequential110_P1_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 6380 \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=10:1 \
		--key-minimum=2621543 \
		--key-maximum=5243086 \
		--key-pattern S:S \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-redistests-keysize70-xxxxxxxxxxxxx- \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Sequential110_P2_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 6381 \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=10:1 \
		--key-minimum=5243086 \
		--key-maximum=7864629 \
		--key-pattern S:S \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-redistests-keysize100-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Sequential110_P3_$(date +"%Y%m%d%H%M%S").log" &
	wait
	echo "===Sequential110 test is end==="

	cleanupdatabases # clean up test databases
}
#prepareDatabase
#cleanupdatabases
Gauss82
Gauss110
Random82
Random110
Sequential82
Sequential110

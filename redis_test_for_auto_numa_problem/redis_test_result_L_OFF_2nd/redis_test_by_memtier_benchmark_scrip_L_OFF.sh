#!/bin/bash
# define globle veriable
OUTPATH="/home/liujianguo/MyTestForAutoNUMA/redis_test_for_auto_numa_problem/redis_test_result_L_OFF_2nd"
CONFIG="memtier_benchmark_L_OFF_2nd"
SERVERADDR="localhost"

# start redis by numactl interleave
function startRedisByNUMAInterleave(){
	echo "====begin configing starting modle===="
	# close numa balance
	#sudo echo 1 > /proc/sys/kernel/numa_balancing
	#wait

	# stop all redis-server
	sudo redis-cli -p 6384 shutdown
        sudo redis-cli -p 6383 shutdown
        sudo redis-cli -p 6382 shutdown
	sudo redis-cli -p 6381 shutdown
	sudo redis-cli -p 6380 shutdown
	sudo sudo /etc/init.d/redis-server stop
	wait
	sleep 5s

	# start redis-server with interleave allocation
#	sudo numactl --interleave=all /etc/init.d/redis-server start
#	sudo numactl --interleave=all redis-server /etc/redis/redis6380.conf
#	sudo numactl --interleave=all redis-server /etc/redis/redis6381.conf
#	sudo numactl --interleave=all redis-server /etc/redis/redis6382.conf
#       sudo numactl --interleave=all redis-server /etc/redis/redis6383.conf
#       sudo numactl --interleave=all redis-server /etc/redis/redis6384.conf

	# start redis-server with local allocation
	sudo /etc/init.d/redis-server start
	sudo redis-server /etc/redis/redis6380.conf
	sudo redis-server /etc/redis/redis6381.conf
	sudo redis-server /etc/redis/redis6382.conf
	sudo redis-server /etc/redis/redis6383.conf
	sudo redis-server /etc/redis/redis6384.conf

	wait
	sleep 5s
	echo "====success starting redis-server with local allocation===="
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
	memtier_benchmark -s $SERVERADDR -p 6382 \
                --threads=20 \
                --clients=5 \
                --requests 100000 \
                --data-size=2048 \
                --ratio=1:0 \
                --key-minimum=7864629 \
                --key-maximum=10486172 \
                --key-pattern P:P \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- &
	memtier_benchmark -s $SERVERADDR -p 6383 \
                --threads=20 \
                --clients=5 \
                --requests 100000 \
                --data-size=2048 \
                --ratio=1:0 \
                --key-minimum=10486172 \
                --key-maximum=13107715 \
                --key-pattern P:P \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-2xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- &
	memtier_benchmark -s $SERVERADDR -p 6384 \
                --threads=20 \
                --clients=5 \
                --requests 100000 \
                --data-size=2048 \
                --ratio=1:0 \
                --key-minimum=13107715 \
                --key-maximum=15729258 \
                --key-pattern P:P \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-3xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- &
	wait
	sleep 5s
	echo "===Database is Ready==="
}

# 清除测试生成数据
function cleanupdatabases(){
	#clean up databases
	echo "===Begin to clean databases==="
	redis-cli -h $SERVERADDR -p 6379 flushall &
	redis-cli -h $SERVERADDR -p 6380 flushall &
	redis-cli -h $SERVERADDR -p 6381 flushall &
	redis-cli -h $SERVERADDR -p 6382 flushall &
	redis-cli -h $SERVERADDR -p 6383 flushall &
	redis-cli -h $SERVERADDR -p 6384 flushall &
	wait
	sleep 5s
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
	#inclease
	memtier_benchmark -s $SERVERADDR -p 6382 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=2:8 \
                --key-minimum=7864629 \
                --key-maximum=10486172 \
                --key-pattern G:G \
                --key-stddev=436923 \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Gauss82_P4_$(date +"%Y%m%d%H%M%S").log" &
	memtier_benchmark -s $SERVERADDR -p 6383 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=2:8 \
                --key-minimum=10486172 \
                --key-maximum=13107715 \
                --key-pattern G:G \
                --key-stddev=436923 \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-2xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Gauss82_P5_$(date +"%Y%m%d%H%M%S").log" &
	memtier_benchmark -s $SERVERADDR -p 6384 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=2:8 \
                --key-minimum=13107715 \
                --key-maximum=15729258 \
                --key-pattern G:G \
                --key-stddev=436923 \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-3xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Gauss82_P6_$(date +"%Y%m%d%H%M%S").log" &
	wait
	sleep 5s
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
	memtier_benchmark -s $SERVERADDR -p 6382 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=10:1 \
                --key-minimum=7864629 \
                --key-maximum=10486172 \
                --key-pattern G:G \
                --key-stddev=436923 \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Gauss110_P4_$(date +"%Y%m%d%H%M%S").log" &
	memtier_benchmark -s $SERVERADDR -p 6383 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=10:1 \
                --key-minimum=10486172 \
                --key-maximum=13107715 \
                --key-pattern G:G \
                --key-stddev=436923 \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-2xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Gauss110_P5_$(date +"%Y%m%d%H%M%S").log" &
	memtier_benchmark -s $SERVERADDR -p 6384 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=10:1 \
                --key-minimum=13107715 \
                --key-maximum=15729258 \
                --key-pattern G:G \
                --key-stddev=436923 \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-3xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Gauss110_P6_$(date +"%Y%m%d%H%M%S").log" &

	wait
	sleep 5s
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
	memtier_benchmark -s $SERVERADDR -p 6382 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=2:8 \
                --key-minimum=7864629 \
                --key-maximum=10486172 \
                --key-pattern R:R \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Random82_P4_$(date +"%Y%m%d%H%M%S").log" &
memtier_benchmark -s $SERVERADDR -p 6383 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=2:8 \
                --key-minimum=10486172 \
                --key-maximum=13107715 \
                --key-pattern R:R \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-2xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Random82_P5_$(date +"%Y%m%d%H%M%S").log" &
memtier_benchmark -s $SERVERADDR -p 6384 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=2:8 \
                --key-minimum=13107715 \
                --key-maximum=15729258 \
                --key-pattern R:R \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-3xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Random82_P6_$(date +"%Y%m%d%H%M%S").log" &
	wait
	sleep 5s
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
	memtier_benchmark -s $SERVERADDR -p 6382 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=10:1 \
                --key-minimum=7864629 \
                --key-maximum=10486172 \
                --key-pattern R:R \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Random110_P4_$(date +"%Y%m%d%H%M%S").log" &
	memtier_benchmark -s $SERVERADDR -p 6383 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=10:1 \
                --key-minimum=10486172 \
                --key-maximum=13107715 \
                --key-pattern R:R \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-2xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Random110_P5_$(date +"%Y%m%d%H%M%S").log" &
	memtier_benchmark -s $SERVERADDR -p 6384 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=10:1 \
                --key-minimum=13107715 \
                --key-maximum=15729258 \
                --key-pattern R:R \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-3xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Random110_P6_$(date +"%Y%m%d%H%M%S").log" &
	wait
	sleep 5s
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
	memtier_benchmark -s $SERVERADDR -p 6382 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=2:8 \
                --key-minimum=7864629 \
                --key-maximum=10486172 \
                --key-pattern S:S \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Sequential82_P4_$(date +"%Y%m%d%H%M%S").log" &
	memtier_benchmark -s $SERVERADDR -p 6383 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=2:8 \
                --key-minimum=10486172 \
                --key-maximum=13107715 \
                --key-pattern S:S \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-2xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Sequential82_P5_$(date +"%Y%m%d%H%M%S").log" &
	memtier_benchmark -s $SERVERADDR -p 6384 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=2:8 \
                --key-minimum=13107715 \
                --key-maximum=15729258 \
                --key-pattern S:S \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-3xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Sequential82_P6_$(date +"%Y%m%d%H%M%S").log" &
	wait
	sleep 5s
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
	memtier_benchmark -s $SERVERADDR -p 6382 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=10:1 \
                --key-minimum=7864629 \
                --key-maximum=10486172 \
                --key-pattern S:S \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Sequential110_P4_$(date +"%Y%m%d%H%M%S").log" &
	memtier_benchmark -s $SERVERADDR -p 6383 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=10:1 \
                --key-minimum=10486172 \
                --key-maximum=13107715 \
                --key-pattern S:S \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-2xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Sequential110_P5_$(date +"%Y%m%d%H%M%S").log" &
	memtier_benchmark -s $SERVERADDR -p 6384 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=10:1 \
                --key-minimum=13107715 \
                --key-maximum=15729258 \
                --key-pattern S:S \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-3xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Sequential110_P6_$(date +"%Y%m%d%H%M%S").log" &
	wait
	sleep 5s
	echo "===Sequential110 test is end==="

	cleanupdatabases # clean up test databases
}

startRedisByNUMAInterleave
#prepareDatabase
#cleanupdatabases
echo "========Start time is: $(date '+%c')========"
Gauss82
Gauss110
Random82
Random110
Sequential82
Sequential110
echo "========End time is: $(date '+%c')========"

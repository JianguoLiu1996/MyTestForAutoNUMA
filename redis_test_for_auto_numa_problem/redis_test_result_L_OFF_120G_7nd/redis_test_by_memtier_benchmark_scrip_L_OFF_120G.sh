#!/bin/bash
# define globle veriable
OUTPUTPATH="/home/liujianguo/MyTestForAutoNUMA/redis_test_for_auto_numa_problem/redis_test_result_L_OFF_120G_7nd/"
CONFIG="memtier_benchmark_L_OFF_120G_7nd"
SERVERADDR="localhost"

# start redis by numactl interleave
function startRedisByNUMAInterleave(){
	echo "====begin configing starting modle===="
	# close numa balance
	#sudo echo 1 > /proc/sys/kernel/numa_balancing
	#wait

	# stop all redis-server
#	sudo redis-cli -p 6390 shutdown
        sudo redis-cli -p 6389 shutdown
        sudo redis-cli -p 6388 shutdown
	sudo redis-cli -p 6387 shutdown
        sudo redis-cli -p 6386 shutdown
        sudo redis-cli -p 6385 shutdown
	sudo redis-cli -p 6384 shutdown
        sudo redis-cli -p 6383 shutdown
        sudo redis-cli -p 6382 shutdown
	sudo redis-cli -p 6381 shutdown
	sudo redis-cli -p 6380 shutdown
	sudo sudo /etc/init.d/redis-server stop
	wait
	sleep 10s

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
	sudo redis-server /etc/redis/redis6385.conf
        sudo redis-server /etc/redis/redis6386.conf
        sudo redis-server /etc/redis/redis6387.conf
	sudo redis-server /etc/redis/redis6388.conf
        sudo redis-server /etc/redis/redis6389.conf
       # sudo redis-server /etc/redis/redis6390.conf

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
		--key-prefix=memtier-benchmark-prefix-redistests 
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
		--key-prefix=memtier-benchmark-prefix-redistests-keysize70-xxxxxxxxxxxxx- 
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
		--key-prefix=memtier-benchmark-prefix-redistests-keysize100-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- 
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
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- 
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
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-2xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- 
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
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-3xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- 
	memtier_benchmark -s $SERVERADDR -p 6385 \
                --threads=20 \
                --clients=5 \
                --requests 100000 \
                --data-size=2048 \
                --ratio=1:0 \
                --key-minimum=15729258 \
                --key-maximum=18350801 \
                --key-pattern P:P \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-4xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- 
	memtier_benchmark -s $SERVERADDR -p 6386 \
                --threads=20 \
                --clients=5 \
                --requests 100000 \
                --data-size=2048 \
                --ratio=1:0 \
                --key-minimum=18350801 \
                --key-maximum=20972344 \
                --key-pattern P:P \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-5xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- 
	memtier_benchmark -s $SERVERADDR -p 6387 \
                --threads=20 \
                --clients=5 \
                --requests 100000 \
                --data-size=2048 \
                --ratio=1:0 \
                --key-minimum=20972344 \
                --key-maximum=23593887 \
                --key-pattern P:P \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-6xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- 
	memtier_benchmark -s $SERVERADDR -p 6388 \
                --threads=20 \
                --clients=5 \
                --requests 100000 \
                --data-size=2048 \
                --ratio=1:0 \
                --key-minimum=23593887 \
                --key-maximum=26215430 \
                --key-pattern P:P \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-7xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- 

	memtier_benchmark -s $SERVERADDR -p 6389 \
                --threads=20 \
                --clients=5 \
                --requests 100000 \
                --data-size=2048 \
                --ratio=1:0 \
                --key-minimum=26215430 \
                --key-maximum=28836973 \
                --key-pattern P:P \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-8xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- 

#	memtier_benchmark -s $SERVERADDR -p 6390 \
#                --threads=20 \
#                --clients=5 \
#                --requests 100000 \
#                --data-size=2048 \
#                --ratio=1:0 \
#                --key-minimum=28836973 \
#                --key-maximum=31458516 \
#                --key-pattern P:P \
#                --pipeline 32 \
#                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-9xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- 

	wait
	sleep 5s
	echo "===Database is Ready==="
}

# 清除测试生成数据
function cleanupdatabases(){
	#clean up databases
	echo "===Begin to clean databases==="
	redis-cli -h $SERVERADDR -p 6379 flushall
	redis-cli -h $SERVERADDR -p 6380 flushall
	redis-cli -h $SERVERADDR -p 6381 flushall
	redis-cli -h $SERVERADDR -p 6382 flushall
	redis-cli -h $SERVERADDR -p 6383 flushall
	redis-cli -h $SERVERADDR -p 6384 flushall
	redis-cli -h $SERVERADDR -p 6385 flushall
        redis-cli -h $SERVERADDR -p 6386 flushall
        redis-cli -h $SERVERADDR -p 6387 flushall
	redis-cli -h $SERVERADDR -p 6388 flushall
        redis-cli -h $SERVERADDR -p 6389 flushall
#        redis-cli -h $SERVERADDR -p 6390 flushall &

	wait
	sleep 5s
	echo "===Databases are cleaned==="
}

# Gauss82 高斯读写，读8写2
function Gauss82(){
	#prepareDatabase # prepare databases for test

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
	memtier_benchmark -s $SERVERADDR -p 6385 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=2:8 \
                --key-minimum=15729258 \
                --key-maximum=18350801 \
                --key-pattern G:G \
                --key-stddev=436923 \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-4xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Gauss82_P7_$(date +"%Y%m%d%H%M%S").log" &
	memtier_benchmark -s $SERVERADDR -p 6386 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=2:8 \
                --key-minimum=18350801 \
                --key-maximum=20972344 \
                --key-pattern G:G \
                --key-stddev=436923 \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-5xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Gauss82_P8_$(date +"%Y%m%d%H%M%S").log" &
	memtier_benchmark -s $SERVERADDR -p 6387 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=2:8 \
                --key-minimum=20972344 \
                --key-maximum=23593887 \
                --key-pattern G:G \
                --key-stddev=436923 \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-6xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Gauss82_P9_$(date +"%Y%m%d%H%M%S").log" &
	memtier_benchmark -s $SERVERADDR -p 6388 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=2:8 \
                --key-minimum=23593887 \
                --key-maximum=26215430 \
                --key-pattern G:G \
                --key-stddev=436923 \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-7xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Gauss82_P10_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 6389 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=2:8 \
                --key-minimum=26215430 \
                --key-maximum=28836973 \
                --key-pattern G:G \
                --key-stddev=436923 \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-8xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Gauss82_P11_$(date +"%Y%m%d%H%M%S").log" &

#	memtier_benchmark -s $SERVERADDR -p 6390 \
#                --threads=20 \
#                --clients=5 \
#                --data-size=2048 \
#                --ratio=2:8 \
#                --key-minimum=28836973 \
#                --key-maximum=31458516 \
#                --key-pattern G:G \
#                --key-stddev=436923 \
#                --pipeline 32 \
#                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-9xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
#                --test-time=900 \
#                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Gauss82_P12_$(date +"%Y%m%d%H%M%S").log" &

	wait
	sleep 5s
	echo "===Gauss82 is test end==="

	#cleanupdatabases # clean up test databases
}

# Gauss110 高斯读写，读1写10
function Gauss110(){
	#prepareDatabase # prepare databases for test

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
	memtier_benchmark -s $SERVERADDR -p 6385 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=10:1 \
                --key-minimum=15729258 \
                --key-maximum=18350801 \
                --key-pattern G:G \
                --key-stddev=436923 \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-4xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Gauss110_P7_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 6386 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=10:1 \
                --key-minimum=18350801 \
                --key-maximum=20972344 \
                --key-pattern G:G \
                --key-stddev=436923 \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-5xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Gauss110_P8_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 6387 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=10:1 \
                --key-minimum=20972344 \
                --key-maximum=23593887 \
                --key-pattern G:G \
                --key-stddev=436923 \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-6xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Gauss110_P9_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 6388 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=10:1 \
                --key-minimum=23593887 \
                --key-maximum=26215430 \
                --key-pattern G:G \
                --key-stddev=436923 \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-7xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Gauss110_P10_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 6389 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=10:1 \
                --key-minimum=26215430 \
                --key-maximum=28836973 \
                --key-pattern G:G \
                --key-stddev=436923 \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-8xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Gauss110_P11_$(date +"%Y%m%d%H%M%S").log" &

#	memtier_benchmark -s $SERVERADDR -p 6390 \
#                --threads=20 \
#                --clients=5 \
#                --data-size=2048 \
#                --ratio=10:1 \
#                --key-minimum=28836973 \
#                --key-maximum=31458516 \
#                --key-pattern G:G \
#                --key-stddev=436923 \
#                --pipeline 32 \
#                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-9xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
#                --test-time=900 \
#                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Gauss110_P12_$(date +"%Y%m%d%H%M%S").log" &


	wait
	sleep 5s
	echo "===Gauss110 is test end==="

	#cleanupdatabases # clean up test databases
}

# Random82 随机读写，读8写2
function Random82(){
	#prepareDatabase # prepare databases for test

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
	memtier_benchmark -s $SERVERADDR -p 6385 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=2:8 \
                --key-minimum=15729258 \
                --key-maximum=18350801 \
                --key-pattern R:R \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-4xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Random82_P7_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 6386 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=2:8 \
                --key-minimum=18350801 \
                --key-maximum=20972344 \
                --key-pattern R:R \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-5xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Random82_P8_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 6387 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=2:8 \
                --key-minimum=20972344 \
                --key-maximum=23593887 \
                --key-pattern R:R \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-6xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Random82_P9_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 6388 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=2:8 \
                --key-minimum=23593887 \
                --key-maximum=26215430 \
                --key-pattern R:R \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-7xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Random82_P10_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 6389 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=2:8 \
                --key-minimum=26215430 \
                --key-maximum=28836973 \
                --key-pattern R:R \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-8xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Random82_P11_$(date +"%Y%m%d%H%M%S").log" &

#	memtier_benchmark -s $SERVERADDR -p 6390 \
#                --threads=20 \
#                --clients=5 \
#                --data-size=2048 \
#                --ratio=2:8 \
#                --key-minimum=28836973 \
#                --key-maximum=31458516 \
#                --key-pattern R:R \
#                --pipeline 32 \
#                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-9xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
#                --test-time=900 \
#                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Random82_P12_$(date +"%Y%m%d%H%M%S").log" &

	wait
	sleep 5s
	echo "===Random82 is test end==="

	#cleanupdatabases # clean up test databases
}

# Random110 随机读写，读1写10
function Random110(){
	#prepareDatabase # prepare databases for test

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
	memtier_benchmark -s $SERVERADDR -p 6385 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=10:1 \
                --key-minimum=15729258 \
                --key-maximum=18350801 \
                --key-pattern R:R \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-4xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Random110_P7_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 6386 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=10:1 \
                --key-minimum=18350801 \
                --key-maximum=20972344 \
                --key-pattern R:R \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-5xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Random110_P8_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 6387 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=10:1 \
                --key-minimum=20972344 \
                --key-maximum=23593887 \
                --key-pattern R:R \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-6xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Random110_P9_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 6388 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=10:1 \
                --key-minimum=23593887 \
                --key-maximum=26215430 \
                --key-pattern R:R \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-7xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Random110_P10_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 6389 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=10:1 \
                --key-minimum=26215430 \
                --key-maximum=28836973 \
                --key-pattern R:R \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-8xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Random110_P11_$(date +"%Y%m%d%H%M%S").log" &

#	memtier_benchmark -s $SERVERADDR -p 6390 \
#                --threads=20 \
#                --clients=5 \
#                --data-size=2048 \
#                --ratio=10:1 \
#                --key-minimum=28836973 \
#                --key-maximum=31458516 \
#                --key-pattern R:R \
#                --pipeline 32 \
#                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-9xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx-  \
#                --test-time=900 \
#                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Random110_P12_$(date +"%Y%m%d%H%M%S").log" &


	wait
	sleep 5s
	echo "===Random110 test is end==="

	#cleanupdatabases # clean up test databases
}

# Sequential82 顺序读写，读8写2
function Sequential82(){
	#prepareDatabase # prepare databases for test

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
	memtier_benchmark -s $SERVERADDR -p 6385 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=2:8 \
                --key-minimum=15729258 \
                --key-maximum=18350801 \
                --key-pattern S:S \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-4xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Sequential82_P7_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 6386 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=2:8 \
                --key-minimum=18350801 \
                --key-maximum=20972344 \
                --key-pattern S:S \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-5xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Sequential82_P8_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 6387 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=2:8 \
                --key-minimum=20972344 \
                --key-maximum=23593887 \
                --key-pattern S:S \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-6xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Sequential82_P9_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 6388 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=2:8 \
                --key-minimum=23593887 \
                --key-maximum=26215430 \
                --key-pattern S:S \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-7xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Sequential82_P10_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 6389 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=2:8 \
                --key-minimum=26215430 \
                --key-maximum=28836973 \
                --key-pattern S:S \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-8xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Sequential82_P11_$(date +"%Y%m%d%H%M%S").log" &

#	memtier_benchmark -s $SERVERADDR -p 6390 \
#                --threads=20 \
#                --clients=5 \
#                --data-size=2048 \
#                --ratio=2:8 \
#                --key-minimum=28836973 \
#                --key-maximum=31458516 \
#                --key-pattern S:S \
#                --pipeline 32 \
#                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-9xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- \
#                --test-time=900 \
#                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Sequential82_P12_$(date +"%Y%m%d%H%M%S").log" &


	wait
	sleep 5s
	echo "===Sequential82 test is end==="

	#cleanupdatabases # clean up test databases
}

# Sequential110 顺序读写，读1写10
function Sequential110(){
	#prepareDatabase # prepare databases for test

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
	memtier_benchmark -s $SERVERADDR -p 6385 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=10:1 \
                --key-minimum=15729258 \
                --key-maximum=18350801 \
                --key-pattern S:S \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-4xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Sequential110_P7_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 6386 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=10:1 \
                --key-minimum=18350801 \
                --key-maximum=20972344 \
                --key-pattern S:S \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-5xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Sequential110_P8_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 6387 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=10:1 \
                --key-minimum=20972344 \
                --key-maximum=23593887 \
                --key-pattern S:S \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-6xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Sequential110_P9_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 6388 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=10:1 \
                --key-minimum=23593887 \
                --key-maximum=26215430 \
                --key-pattern S:S \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-7xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Sequential110_P10_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 6389 \
                --threads=20 \
                --clients=5 \
                --data-size=2048 \
                --ratio=10:1 \
                --key-minimum=26215430 \
                --key-maximum=28836973 \
                --key-pattern S:S \
                --pipeline 32 \
                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-8xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- \
                --test-time=900 \
                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Sequential110_P11_$(date +"%Y%m%d%H%M%S").log" &

#	memtier_benchmark -s $SERVERADDR -p 6390 \
#                --threads=20 \
#                --clients=5 \
#                --data-size=2048 \
#                --ratio=10:1 \
#                --key-minimum=28836973 \
#                --key-maximum=31458516 \
#                --key-pattern S:S \
#                --pipeline 32 \
#                --key-prefix=memtier-benchmark-prefix-redistests-keysize100-9xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- \
#                --test-time=900 \
#                --distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Sequential110_P12_$(date +"%Y%m%d%H%M%S").log" &


	wait
	sleep 5s
	echo "===Sequential110 test is end==="

	#cleanupdatabases # clean up test databases
}

function Gauss82three(){
	OUTPUTPATH="/home/liujianguo/MyTestForAutoNUMA/redis_test_for_auto_numa_problem/redis_test_result_L_OFF_120G_7nd/"
	CONFIG="memtier_benchmark_L_OFF_120G_7nd"
	Gauss82
	sleep 60s

	echo "========second test========"
	OUTPUTPATH="/home/liujianguo/MyTestForAutoNUMA/redis_test_for_auto_numa_problem/redis_test_result_L_OFF_120G_8nd/"
	CONFIG="memtier_benchmark_L_OFF_120G_8nd"
	Gauss82
	sleep 60s
	
	echo "========third test========"
	OUTPUTPATH="/home/liujianguo/MyTestForAutoNUMA/redis_test_for_auto_numa_problem/redis_test_result_L_OFF_120G_9nd/"
	CONFIG="memtier_benchmark_L_OFF_120G_9nd"
	Gauss82
	sleep 60s
}

function Gauss110three(){
        OUTPUTPATH="/home/liujianguo/MyTestForAutoNUMA/redis_test_for_auto_numa_problem/redis_test_result_L_OFF_120G_7nd/"
        CONFIG="memtier_benchmark_L_OFF_120G_7nd"
        Gauss110
        sleep 60s

        echo "========second test========"
        OUTPUTPATH="/home/liujianguo/MyTestForAutoNUMA/redis_test_for_auto_numa_problem/redis_test_result_L_OFF_120G_8nd/"
        CONFIG="memtier_benchmark_L_OFF_120G_8nd"
        Gauss110
        sleep 60s

        echo "========third test========"
        OUTPUTPATH="/home/liujianguo/MyTestForAutoNUMA/redis_test_for_auto_numa_problem/redis_test_result_L_OFF_120G_9nd/"
        CONFIG="memtier_benchmark_L_OFF_120G_9nd"
        Gauss110
	sleep 60s
}

function Random82three(){
        OUTPUTPATH="/home/liujianguo/MyTestForAutoNUMA/redis_test_for_auto_numa_problem/redis_test_result_L_OFF_120G_7nd/"
        CONFIG="memtier_benchmark_L_OFF_120G_7nd"
        Random82
        sleep 60s

        echo "========second test========"
        OUTPUTPATH="/home/liujianguo/MyTestForAutoNUMA/redis_test_for_auto_numa_problem/redis_test_result_L_OFF_120G_8nd/"
        CONFIG="memtier_benchmark_L_OFF_120G_8nd"
        Random82
        sleep 60s

        echo "========third test========"
        OUTPUTPATH="/home/liujianguo/MyTestForAutoNUMA/redis_test_for_auto_numa_problem/redis_test_result_L_OFF_120G_9nd/"
        CONFIG="memtier_benchmark_L_OFF_120G_9nd"
        Random82
        sleep 60s
}

function Random110three(){
        OUTPUTPATH="/home/liujianguo/MyTestForAutoNUMA/redis_test_for_auto_numa_problem/redis_test_result_L_OFF_120G_7nd/"
        CONFIG="memtier_benchmark_L_OFF_120G_7nd"
        Random110
        sleep 60s

        echo "========second test========"
        OUTPUTPATH="/home/liujianguo/MyTestForAutoNUMA/redis_test_for_auto_numa_problem/redis_test_result_L_OFF_120G_8nd/"
        CONFIG="memtier_benchmark_L_OFF_120G_8nd"
        Random110
        sleep 60s

        echo "========third test========"
        OUTPUTPATH="/home/liujianguo/MyTestForAutoNUMA/redis_test_for_auto_numa_problem/redis_test_result_L_OFF_120G_9nd/"
        CONFIG="memtier_benchmark_L_OFF_120G_9nd"
        Random110
        sleep 60s
}

function Sequential82three(){
        OUTPUTPATH="/home/liujianguo/MyTestForAutoNUMA/redis_test_for_auto_numa_problem/redis_test_result_L_OFF_120G_7nd/"
        CONFIG="memtier_benchmark_L_OFF_120G_7nd"
	Sequential82
        sleep 60s

        echo "========second test========"
        OUTPUTPATH="/home/liujianguo/MyTestForAutoNUMA/redis_test_for_auto_numa_problem/redis_test_result_L_OFF_120G_8nd/"
        CONFIG="memtier_benchmark_L_OFF_120G_8nd"
	Sequential82
        sleep 60s

        echo "========third test========"
        OUTPUTPATH="/home/liujianguo/MyTestForAutoNUMA/redis_test_for_auto_numa_problem/redis_test_result_L_OFF_120G_9nd/"
        CONFIG="memtier_benchmark_L_OFF_120G_9nd"
	Sequential82
        sleep 60s
}

function Sequential110three(){
        OUTPUTPATH="/home/liujianguo/MyTestForAutoNUMA/redis_test_for_auto_numa_problem/redis_test_result_L_OFF_120G_7nd/"
        CONFIG="memtier_benchmark_L_OFF_120G_7nd"
        Sequential110
        sleep 60s

        echo "========second test========"
        OUTPUTPATH="/home/liujianguo/MyTestForAutoNUMA/redis_test_for_auto_numa_problem/redis_test_result_L_OFF_120G_8nd/"
        CONFIG="memtier_benchmark_L_OFF_120G_8nd"
        Sequential110
        sleep 60s

        echo "========third test========"
        OUTPUTPATH="/home/liujianguo/MyTestForAutoNUMA/redis_test_for_auto_numa_problem/redis_test_result_L_OFF_120G_9nd/"
        CONFIG="memtier_benchmark_L_OFF_120G_9nd"
        Sequential110
        sleep 60s
}
function alltest(){
	startRedisByNUMAInterleave
	prepareDatabase

	Gauss82three
	Gauss110three
	Random82three
	Random110three
	Sequential82three
	Sequential110three
	
	cleanupdatabases
}

#startRedisByNUMAInterleave
#prepareDatabase
#cleanupdatabases
echo "========Start time is: $(date '+%c')========"
start_time=$(date +%s)  # 记录脚本开始时间（秒级时间戳）
#Gauss82
#Gauss110
#Random82
#Random110
#Sequential82
#Sequential110

alltest

end_time=$(date +%s)   #记录脚本结束时间（秒级时间戳）
runtime=$((end_time - start_time))   #计算脚本运行时间（单位：秒）
echo "脚本运行时间为：$runtime 秒"
echo "========End time is: $(date '+%c')========"

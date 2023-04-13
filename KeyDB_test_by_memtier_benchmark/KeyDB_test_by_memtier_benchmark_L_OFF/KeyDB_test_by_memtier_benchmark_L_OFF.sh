#!/bin/bash
# define globle veriable
OUTPATH="/home/liujianguo/MyTestForAutoNUMA/KeyDB_test_by_memtier_benchmark/KeyDB_test_by_memtier_benchmark_L_OFF/"
# defin output file name
CONFIG="KeyDB_test_L_OFF"
RESULT="Result"
LOG="Log"
# define server addr
#SERVERADDR="127.0.0.1"
SERVERADDR="192.168.1.2"

# start KeyDB by numactl interleave
function startmemcached(){
	echo "====begin configing starting modle===="
	# close numa balance
	#sudo echo 1 > /proc/sys/kernel/numa_balancing
	#wait

	# stop all KeyDB-server
	echo "====begin stop keydb-server==="
	sudo service keydb-server stop
	wait
	sleep 3s
	echo "====success to start keydb-server==="

	# start redis-server with interleave allocation
	echo "===begin start keydb-server==="
	#sudo numactl --interleave=all service keydb-server start

	# start KeyDB with local allocation
	sudo service keydb-server start
	echo "===success to start keydb-server==="

	wait
	sleep 3s
	echo "====success starting memcached with special config===="
}

# 准备数据
function prepareDatabase(){
	memtier_benchmark -s $SERVERADDR -p 6379 \
		--threads=50 \
		--clients=8 \
		--requests 100000 \
		--data-size=256 \
		--ratio=1:0 \
		--key-minimum=1 \
		--key-maximum=45600000 \
		--key-pattern P:P \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-redistests \
		--out-file=./PrepareData_${CONFIG}_$(date +"%Y%m%d%H%M%S").txt
	wait
	echo "===Database is Ready==="
}

# 清除测试生成数据
function cleanupdatabases(){
	#clean up databases
	echo "===Begin to clean databases==="
	keydb-cli FLUSHALL
	echo "quit" | keydb-cli

	wait
	sleep 3s
	echo "===Databases are cleaned==="
}

# Gauss82 高斯读写，读8写2
function Gauss82(){
	prepareDatabase # prepare databases for test

	echo "===begin test for Gauss82==="
	memtier_benchmark -s $SERVERADDR -p 6379 \
		--threads=50 \
		--clients=8 \
		--data-size=256 \
		--ratio=2:8 \
		--key-minimum=1 \
		--key-maximum=45600000 \
		--key-pattern G:G \
		--key-stddev=366666 \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-redistests \
		--out-file=./${RESULT}_${CONFIG}_Gauss82_$(date +"%Y%m%d%H%M%S").txt \
		--test-time=900 \
		--distinct-client-seed >> ./${LOG}_${CONFIG}_Gauss82_$(date +"%Y%m%d%H%M%S").log 2>&1

	wait
	echo "===Gauss82 is test end==="

	cleanupdatabases # clean up test databases
}

# Gauss110 高斯读写，读1写10
function Gauss110(){
	prepareDatabase # prepare databases for test

	echo "===begin test for Gauss110==="
	memtier_benchmark -s $SERVERADDR -p 6379 \
		--threads=50 \
		--clients=8 \
		--data-size=256 \
		--ratio=10:1 \
		--key-minimum=1 \
		--key-maximum=45600000 \
		--key-pattern G:G \
		--key-stddev=366666 \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-redistests \
		--out-file=./${RESULT}_${CONFIG}_Gauss110_$(date +"%Y%m%d%H%M%S").txt \
		--test-time=900 \
		--distinct-client-seed >> ./${LOG}_${CONFIG}_Gauss110_$(date +"%Y%m%d%H%M%S").log 2>&1

	wait
	echo "===end test for Gauss110==="

	cleanupdatabases # clean up test databases
}

# Random82 随机读写，读8写2
function Random82(){
	prepareDatabase # prepare databases for test

	echo "===begin test for Random82==="
	memtier_benchmark -s $SERVERADDR -p 6379 \
		--threads=50 \
		--clients=8 \
		--data-size=256 \
		--ratio=2:8 \
		--key-minimum=1 \
		--key-maximum=45600000 \
		--key-pattern R:R \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-redistests \
		--out-file=./${RESULT}_${CONFIG}_Random82_$(date +"%Y%m%d%H%M%S").txt \
		--test-time=900 \
		--distinct-client-seed >> ./${LOG}_${CONFIG}_Random82_$(date +"%Y%m%d%H%M%S").log 2>&1

	wait
	echo "===Random82 is test end==="

	cleanupdatabases # clean up test databases
}

# Random110 随机读写，读1写10
function Random110(){
	prepareDatabase # prepare databases for test
	
	echo "===Begin test for Random110==="
	memtier_benchmark -s $SERVERADDR -p 6379 \
		--threads=50 \
		--clients=8 \
		--data-size=256 \
		--ratio=10:1 \
		--key-minimum=1 \
		--key-maximum=45600000 \
		--key-pattern R:R \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-redistests \
		--out-file=./${RESULT}_${CONFIG}_Random110_$(date +"%Y%m%d%H%M%S").txt \
		--test-time=900 \
		--distinct-client-seed >> ./${LOG}_${CONFIG}_Random110_$(date +"%Y%m%d%H%M%S").log 2>&1

	wait
	echo "===End test for Random110==="

	cleanupdatabases # clean up test databases
}

# Sequential82 顺序读写，读8写2
function Sequential82(){
	prepareDatabase # prepare databases for test

	echo "===Begin test for Sequential82==="
	memtier_benchmark -s $SERVERADDR -p 6379 \
		--threads=50 \
		--clients=8 \
		--data-size=256 \
		--ratio=2:8 \
		--key-minimum=1 \
		--key-maximum=45600000 \
		--key-pattern S:S \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-redistests \
		--out-file=./${RESULT}_${CONFIG}_Sequential82_$(date +"%Y%m%d%H%M%S").txt \
		--test-time=900 \
		--distinct-client-seed >> ./${LOG}_${CONFIG}_Sequential82_$(date +"%Y%m%d%H%M%S").log 2>&1
	wait
	echo "===End test for Sequential82==="

	cleanupdatabases # clean up test databases
}

# Sequential110 顺序读写，读1写10
function Sequential110(){
	prepareDatabase # prepare databases for test

	echo "===Bengin test for Sequential110==="
	memtier_benchmark -s $SERVERADDR -p 6379 \
		--threads=50 \
		--clients=8 \
		--data-size=256 \
		--ratio=10:1 \
		--key-minimum=1 \
		--key-maximum=45600000 \
		--key-pattern S:S \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-redistests \
		--out-file=./${RESULT}_${CONFIG}_Sequential110_$(date +"%Y%m%d%H%M%S").txt \
		--test-time=900 \
		--distinct-client-seed >> ./${LOG}_${CONFIG}_Sequential110_$(date +"%Y%m%d%H%M%S").log 2>&1

	wait
	echo "===Sequential110 test is end==="

	cleanupdatabases # clean up test databases
}

# Sequential10 顺序读写，读1写0
function Sequential10(){
	prepareDatabase # prepare databases for test

	echo "===Bengin test for Sequential10==="
	memtier_benchmark -s $SERVERADDR -p 6379 \
		--threads=50 \
		--clients=8 \
		--data-size=256 \
		--ratio=1:0 \
		--key-minimum=1 \
		--key-maximum=45600000 \
		--key-pattern S:S \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-redistests \
		--out-file=./${RESULT}_${CONFIG}_Sequential10_$(date +"%Y%m%d%H%M%S").txt \
		--test-time=900 \
		--distinct-client-seed >> ./${LOG}_${CONFIG}_Sequential10_$(date +"%Y%m%d%H%M%S").log 2>&1

	wait
	echo "===Sequential10 test is end==="

	cleanupdatabases # clean up test databases
}

# Sequential01 顺序读写，读0写1
function Sequential01(){
	prepareDatabase # prepare databases for test

	echo "===Bengin test for Sequential01==="
	memtier_benchmark -s $SERVERADDR -p 6379 \
		--threads=50 \
		--clients=8 \
		--data-size=256 \
		--ratio=0:1 \
		--key-minimum=1 \
		--key-maximum=45600000 \
		--key-pattern S:S \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-redistests \
		--out-file=./${RESULT}_${CONFIG}_Sequential01_$(date +"%Y%m%d%H%M%S").txt \
		--test-time=900 \
		--distinct-client-seed >> ./${LOG}_${CONFIG}_Sequential01_$(date +"%Y%m%d%H%M%S").log 2>&1

	wait
	echo "===Sequential01 test is end==="

	cleanupdatabases # clean up test databases
}

# start test
startmemcached
#prepareDatabase
#cleanupdatabases
echo "========Start time is: $(date '+%c')========"
Gauss82
#Gauss110
#Random82
#Random110
#Sequential82
#Sequential110
#Sequential10
#Sequential01
echo "========End time is: $(date '+%c')========"

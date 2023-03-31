#!bash
# define globle veriable
OUTPATH="/home/liujianguo/MyTestForAutoNUMA/memcached_test_by_memtier_benchmark/memcached_Experiment_I_ON/"
CONFIG="memcached_I_ON"
SERVERADDR="127.0.0.1"

# start redis by numactl interleave
function startmemcached(){
	echo "====begin configing starting modle===="
	# close numa balance
	#sudo echo 1 > /proc/sys/kernel/numa_balancing
	#wait

	# stop all memcached
	sudo killall memcached
	sudo service memcached  stop
	wait
	sleep 3s

	# start redis-server with interleave allocation
	sudo numactl --interleave=all /etc/init.d/memcached start
	sudo numactl --interleave=all memcached -d -u root -p 11212 -m 10240
	sudo numactl --interleave=all memcached -d -u root -p 11213 -m 10240

	# start memcached with local allocation
#	sudo /etc/init.d/memcached start
#	sudo memcached -d -u root -p 11212 -m 10240
#	sudo memcached -d -u root -p 11213 -m 10240

	wait
	sleep 3s
	echo "====success starting memcached with special config===="
}

# 准备三个进程的数据
function prepareDatabase(){
	echo "===Begin prepare Database==="
	memtier_benchmark -s $SERVERADDR -p 11211 -P memcache_text \
		--threads=20 \
		--clients=5 \
		--requests 100000 \
		--data-size=2048 \
		--ratio=1:0 \
		--key-minimum=1 \
		--key-maximum=2621543 \
		--key-pattern P:P \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-memcachedtests &
	
	memtier_benchmark -s $SERVERADDR -p 11212 -P memcache_text \
		--threads=20 \
		--clients=5 \
		--requests 100000 \
		--data-size=2048 \
		--ratio=1:0 \
		--key-minimum=2621543 \
		--key-maximum=5243086 \
		--key-pattern P:P \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-memcachedtests-keysize70-xxxxxxxxxxxxx- &
	
	memtier_benchmark -s $SERVERADDR -p 11213 -P memcache_text \
		--threads=20 \
		--clients=5 \
		--requests 100000 \
		--data-size=2048 \
		--ratio=1:0 \
		--key-minimum=5243086 \
		--key-maximum=7864629 \
		--key-pattern P:P \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-memcachedtests-keysize100-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- &
	wait
	echo "===Database is Ready==="
}

# 清除测试生成数据
function cleanupdatabases(){
	#clean up databases
	echo "===Begin to clean databases==="
	echo "flush_all" | nc -q 2 $SERVERADDR 11211 &
	echo "flush_all" | nc -q 2 $SERVERADDR 11212 &
	echo "flush_all" | nc -q 2 $SERVERADDR 11213 &
	wait
	echo "===Databases are cleaned==="
}

# Gauss82 高斯读写，读8写2
function Gauss82(){
	prepareDatabase # prepare databases for test

	echo "===begin test for Gauss82==="
	memtier_benchmark -s $SERVERADDR -p 11211 -P memcache_text \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=2:8 \
		--key-minimum=1 \
		--key-maximum=2621543 \
		--key-pattern G:G \
		--key-stddev=436923 \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-memcachedtests \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Gauss82_P1_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 11212 -P memcache_text \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=2:8 \
		--key-minimum=2621543 \
		--key-maximum=5243086 \
		--key-pattern G:G \
		--key-stddev=436923 \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-memcachedtests-keysize70-xxxxxxxxxxxxx- \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Gauss82_P2_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 11213 -P memcache_text \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=2:8 \
		--key-minimum=5243086 \
		--key-maximum=7864629 \
		--key-pattern G:G \
		--key-stddev=436923 \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-memcachedtests-keysize100-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- \
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
	memtier_benchmark -s $SERVERADDR -p 11211 -P memcache_text \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=10:1 \
		--key-minimum=1 \
		--key-maximum=2621543 \
		--key-pattern G:G \
		--key-stddev=436923 \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-memcachedtests \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Gauss110_P1_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 11212 -P memcache_text \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=10:1 \
		--key-minimum=2621543 \
		--key-maximum=5243086 \
		--key-pattern G:G \
		--key-stddev=436923 \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-memcachedtests-keysize70-xxxxxxxxxxxxx- \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Gauss110_P2_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 11213 -P memcache_text \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=10:1 \
		--key-minimum=5243086 \
		--key-maximum=7864629 \
		--key-pattern G:G \
		--key-stddev=436923 \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-memcachedtests-keysize100-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Gauss110_P3_$(date +"%Y%m%d%H%M%S").log" &
	wait
	echo "===end test for Gauss110==="

	cleanupdatabases # clean up test databases
}

# Random82 随机读写，读8写2
function Random82(){
	prepareDatabase # prepare databases for test

	echo "===begin test for Random82==="
	memtier_benchmark -s $SERVERADDR -p 11211 -P memcache_text \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=2:8 \
		--key-minimum=1 \
		--key-maximum=2621543 \
		--key-pattern R:R \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-memcachedtests \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Random82_P1_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 11212 -P memcache_text \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=2:8 \
		--key-minimum=2621543 \
		--key-maximum=5243086 \
		--key-pattern R:R \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-memcachedtests-keysize70-xxxxxxxxxxxxx- \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Random82_P2_$(date +"%Y%m%d%H%M%S").log" &
	
	memtier_benchmark -s $SERVERADDR -p 11213 -P memcache_text \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=2:8 \
		--key-minimum=5243086 \
		--key-maximum=7864629 \
		--key-pattern R:R \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-memcachedtests-keysize100-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- \
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
	memtier_benchmark -s $SERVERADDR -p 11211 -P memcache_text \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=10:1 \
		--key-minimum=1 \
		--key-maximum=2621543 \
		--key-pattern R:R --pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-memcachedtests \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Random110_P1_$(date +"%Y%m%d%H%M%S").log" &
	
	memtier_benchmark -s $SERVERADDR -p 11212 -P memcache_text \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=10:1 \
		--key-minimum=2621543 \
		--key-maximum=5243086 \
		--key-pattern R:R \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-memcachedtests-keysize70-xxxxxxxxxxxxx- \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Random110_P2_$(date +"%Y%m%d%H%M%S").log" &
	
	memtier_benchmark -s $SERVERADDR -p 11213 -P memcache_text \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=10:1 \
		--key-minimum=5243086 \
		--key-maximum=7864629 \
		--key-pattern R:R \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-memcachedtests-keysize100-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Random110_P3_$(date +"%Y%m%d%H%M%S").log" &
	wait
	echo "===End test for Random110==="

	cleanupdatabases # clean up test databases
}

# Sequential82 顺序读写，读8写2
function Sequential82(){
	prepareDatabase # prepare databases for test

	echo "===Begin test for Sequential82==="
	memtier_benchmark -s $SERVERADDR -p 11211 -P memcache_text \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=2:8 \
		--key-minimum=1 \
		--key-maximum=2621543 \
		--key-pattern S:S \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-memcachedtests \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Sequential82_P1_$(date +"%Y%m%d%H%M%S").log" &
	
	memtier_benchmark -s $SERVERADDR -p 11212 -P memcache_text \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=2:8 \
		--key-minimum=2621543 \
		--key-maximum=5243086 \
		--key-pattern S:S \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-memcachedtests-keysize70-xxxxxxxxxxxxx- \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Sequential82_P2_$(date +"%Y%m%d%H%M%S").log" &

	memtier_benchmark -s $SERVERADDR -p 11213 -P memcache_text \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=2:8 \
		--key-minimum=5243086 \
		--key-maximum=7864629 \
		--key-pattern S:S \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-memcachedtests-keysize100-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Sequential82_P3_$(date +"%Y%m%d%H%M%S").log" &
	wait
	echo "===End test for Sequential82==="

	cleanupdatabases # clean up test databases
}

# Sequential110 顺序读写，读1写10
function Sequential110(){
	prepareDatabase # prepare databases for test

	echo "===Bengin test for Sequential110==="
	memtier_benchmark -s $SERVERADDR -p 11211 -P memcache_text \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=10:1 \
		--key-minimum=1 \
		--key-maximum=2621543 \
		--key-pattern S:S \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-memcachedtests \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Sequential110_P1_$(date +"%Y%m%d%H%M%S").log" &
	
	memtier_benchmark -s $SERVERADDR -p 11212 -P memcache_text \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=10:1 \
		--key-minimum=2621543 \
		--key-maximum=5243086 \
		--key-pattern S:S \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-memcachedtests-keysize70-xxxxxxxxxxxxx- \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Sequential110_P2_$(date +"%Y%m%d%H%M%S").log" &
	
	memtier_benchmark -s $SERVERADDR -p 11213 -P memcache_text \
		--threads=20 \
		--clients=5 \
		--data-size=2048 \
		--ratio=10:1 \
		--key-minimum=5243086 \
		--key-maximum=7864629 \
		--key-pattern S:S \
		--pipeline 32 \
		--key-prefix=memtier-benchmark-prefix-memcachedtests-keysize100-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx- \
		--test-time=900 \
		--distinct-client-seed >> "${OUTPUTPATH}${CONFIG}_Sequential110_P3_$(date +"%Y%m%d%H%M%S").log" &
	wait
	echo "===Sequential110 test is end==="

	cleanupdatabases # clean up test databases
}
startmemcached
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

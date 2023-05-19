#!/bin/bash
function startHadoop(){
	cd /opt/module/hadoop-3.3.5/sbin 
	./start-dfs.sh
	sleep 1s
	hadoop dfsadmin -safemode leave
	sleep 1s
	./start-yarn.sh
	sleep 1s
	mr-jobhistory-daemon.sh start historyserver
	sleep 1s
}
function startHadoopbyNumaInterleave(){
        cd /opt/module/hadoop-3.3.5/sbin
        numactl --interleave=all ./start-dfs.sh
	sleep 1s
        hadoop dfsadmin -safemode leave
        sleep 1s
        numactl --interleave=all ./start-yarn.sh
        sleep 1s
        numactl --interleave=all mr-jobhistory-daemon.sh start historyserver
	sleep 1s
}

function startHive(){
	nohup hive --service metastore &
	sleep 1s
	nohup hive --service hiveserver2 &
	sleep 1s
}
function startHivebyNumaInterleave(){
        nohup numactl --interleave=all hive --service metastore &
        sleep 1s
        nohup numactl --interleave=all hive --service hiveserver2 &
	sleep 1s
}
function stopHadoop(){
	cd /opt/module/hadoop-3.3.5/sbin
	mr-jobhistory-daemon.sh stop historyserver
	sleep 1s
	./stop-yarn.sh
	sleep 1s
	./stop-dfs.sh
}
function testHivebytpcds(){
	cd /home/liujianguo/MyTestForAutoNUMA/Hive_test/BaBench/bin
	for((i=1;i<=3;i++))
	do
	#	./TestHiveWithTpcds.sh >> TestHiveWithTpcdsOutput-I-ON-${i}nd-20230519.txt
		numactl --interleave=all ./TestHiveWithTpcds.sh >> TestHiveWithTpcdsOutput-I-ON-${i}nd-20230519.txt
	done
}
#startHadoop
#startHadoopbyNumaInterleave
#startHive
#startHivebyNumaInterleave
#stopHadoop
testHivebytpcds

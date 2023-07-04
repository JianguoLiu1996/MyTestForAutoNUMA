#!/bin/bash
OUTPUTPATH=/home/liujianguo/MyTestForAutoNUMA/mysql_test_for_auto_numa_problem/mysql_test_for_auto_numa_64_10M_L_OFF/
NUMBER=1nd
CONFIG=L_OFF_64_10M
function rwtest(){
	echo "==Prepare data for RW=="
	sysbench /home/liujianguo/Download/sysbench-1.0.11/tests/include/oltp_legacy/oltp.lua \
		--threads=100 \
		--oltp-table-size=10000000 \
		--oltp-tables-count=64 \
		--mysql-db=testdb \
		--db-driver=mysql \
		--mysql-host=localhost \
		--mysql-port=3306 \
		--mysql-user=root \
		--mysql-password=123456 \
		--report-interval=3 prepare >> "${OUTPUTPATH}mysysbench_rw_prepare_${CONFIG}_${NUMBER}_$(date +"%Y%m%d%H%M%S").log"
	wait
	sleep 1m

	echo "==run sysbench for RW=="
	echo "Start time is: $(date '+%c')"
	sysbench /home/liujianguo/Download/sysbench-1.0.11/tests/include/oltp_legacy/oltp.lua \
		--threads=200 \
		--time=1800 \
		--max-requests=0 \
		--mysql-db=testdb \
		--oltp-table-size=10000000 \
		--oltp-tables-count=64 \
		--db-driver=mysql \
		--mysql-host=localhost \
		--mysql-port=3306 \
		--mysql-user=root \
		--mysql-password=123456 \
		--report-interval=3 \
		--forced-shutdown=1 run >> "${OUTPUTPATH}mysysbench_rw_${CONFIG}_${NUMBER}_$(date +"%Y%m%d%H%M%S").log"
	echo "End time is: $(date '+%c')"

	wait
	sleep 1m
	echo "==cleanup sysbench testdb of RW=="
	sysbench /home/liujianguo/Download/sysbench-1.0.11/tests/include/oltp_legacy/oltp.lua \
	 	--threads=200 \
	 	--time=1800 \
	 	--max-requests=0 \
	 	--mysql-db=testdb \
	 	--oltp-table-size=10000000 \
		--oltp-tables-count=64 \
	 	--db-driver=mysql \
		--mysql-host=localhost \
		--mysql-port=3306 \
		--mysql-user=root \
	 	--mysql-password=123456 \
	 	--report-interval=3 \
	 	--forced-shutdown=1 cleanup
	wait
	sleep 1m
}

function rotest(){
	echo "==Prepare data for RO=="
	sysbench /home/liujianguo/Download/sysbench-1.0.11/tests/include/oltp_legacy/oltp.lua \
	 	--threads=100 \
	 	--oltp-table-size=10000000 \
	 	--oltp-tables-count=64 \
	 	--mysql-db=testdb \
	 	--db-driver=mysql \
	 	--mysql-host=localhost \
	 	--mysql-port=3306 \
	 	--mysql-user=root \
	 	--mysql-password=123456 \
	 	--report-interval=3 prepare >> "${OUTPUTPATH}mysysbench_ro_prepare_${CONFIG}_${NUMBER}_$(date +"%Y%m%d%H%M%S").log"

	wait
	sleep 1m

	echo "==run sysbench test for RO=="
	echo "Start time is: $(date '+%c')"
	sysbench /home/liujianguo/Download/sysbench-1.0.11/tests/include/oltp_legacy/oltp.lua \
		--mysql-host=localhost \
		--oltp-tables-count=64 \
		--mysql-user=root \
		--mysql-password=123456 \
		--mysql-port=3306 \
		--db-driver=mysql \
		--oltp-table-size=10000000 \
		--mysql-db=testdb \
		--max-requests=0 \
		--oltp-simple-ranges=0 \
		--oltp-distinct-ranges=0 \
		--oltp-sum-ranges=0 \
		--oltp-order-ranges=0 \
		--time=1800 \
		--oltp-read-only=on \
		--threads=200 \
		--report-interval=3 \
		--thread-init-timeout=300 \
		--forced-shutdown=1 run >> "${OUTPUTPATH}mysysbench_ro_${CONFIG}_${NUMBER}_$(date +"%Y%m%d%H%M%S").log"
	echo "End time is: $(date '+%c')"
	wait
	sleep 1m

	echo "==cleanup sysbench testdb for RO=="
	sysbench /home/liujianguo/Download/sysbench-1.0.11/tests/include/oltp_legacy/oltp.lua \
		--mysql-host=localhost \
		--oltp-tables-count=64 \
		--mysql-user=root \
		--mysql-password=123456 \
		--mysql-port=3306 \
		--db-driver=mysql \
		--oltp-table-size=10000000 \
		--mysql-db=testdb \
		--max-requests=0 \
		--oltp-simple-ranges=0 \
		--oltp-distinct-ranges=0 \
		--oltp-sum-ranges=0 \
		--oltp-order-ranges=0 \
		--time=1800 \
		--oltp-read-only=on \
		--threads=200 \
		--report-interval=3 \
		--thread-init-timeout=300 \
		--forced-shutdown=1 cleanup
	wait
	sleep 1m
}

function wotest(){
	echo "==Prepare data for WO=="
	sysbench /home/liujianguo/Download/sysbench-1.0.11/tests/include/oltp_legacy/oltp.lua \
	 	--threads=100 \
	 	--oltp-table-size=10000000 \
	 	--oltp-tables-count=64 \
	 	--mysql-db=testdb \
	 	--db-driver=mysql \
	 	--mysql-host=localhost \
	 	--mysql-port=3306 \
	 	--mysql-user=root \
	 	--mysql-password=123456 \
	 	--report-interval=3 prepare >> "${OUTPUTPATH}mysysbench_wo_prepare_${CONFIG}_${NUMBER}_$(date +"%Y%m%d%H%M%S").log"
	wait
	sleep 1m

	echo "== run sysbench for WO=="
	echo "Start time is: $(date '+%c')"
	sysbench /home/liujianguo/Download/sysbench-1.0.11/tests/include/oltp_legacy/oltp.lua \
		--mysql-host=localhost \
		--oltp-tables-count=64 \
		--mysql-user=root \
		--mysql-password=123456 \
		--mysql-port=3306 \
		--db-driver=mysql \
		--oltp-table-size=10000000 \
		--mysql-db=testdb \
		--max-requests=0 \
		--max-time=1800 \
		--oltp-simple-ranges=0 \
		--oltp-distinct-ranges=0 \
		--oltp-sum-ranges=0 \
		--oltp-order-ranges=0 \
		--oltp-point-selects=0 \
		--threads=200 \
		--randtype=uniform \
		--report-interval=3 \
		--thread-init-timeout=300 \
		--forced-shutdown=1 run >> "${OUTPUTPATH}mysysbench_wo_${CONFIG}_${NUMBER}_$(date +"%Y%m%d%H%M%S").log"
	echo "End time is: $(date '+%c')"
	wait
	sleep 1m

	echo "== run sysbench for WO"
       	sysbench /home/liujianguo/Download/sysbench-1.0.11/tests/include/oltp_legacy/oltp.lua \
		--mysql-host=localhost \
                --oltp-tables-count=64 \
                --mysql-user=root \
                --mysql-password=123456 \
                --mysql-port=3306 \
                --db-driver=mysql \
                --oltp-table-size=10000000 \
                --mysql-db=testdb \
                --max-requests=0 \
                --max-time=1800 \
                --oltp-simple-ranges=0 \
                --oltp-distinct-ranges=0 \
                --oltp-sum-ranges=0 \
                --oltp-order-ranges=0 \
                --oltp-point-selects=0 \
                --threads=200 \
                --randtype=uniform \
                --report-interval=3 \
                --thread-init-timeout=300 \
                --forced-shutdown=1 cleanup
	wait
	sleep 1m
	echo "test end"
}
function startMysql(){
	sudo /etc/init.d/mysql restart
	sleep 30s
}

#three times test
function alltest(){
	start_time=$(date +%s)  # 获取脚本开始时间（以秒为单位）

#	#第一次测试
#	startMysql
#	rwtest
#	rotest
#	wotest
#
#	#第二次测试	
#	OUTPUTPATH=/home/liujianguo/MyTestForAutoNUMA/mysql_test_for_auto_numa_problem/mysql_test_for_auto_numa_64_10M_L_OFF_2nd/
#	NUMBER=2nd
#	startMysql
#        rwtest
#        rotest
#        wotest
	
	#第三次测试
	OUTPUTPATH=/home/liujianguo/MyTestForAutoNUMA/mysql_test_for_auto_numa_problem/mysql_test_for_auto_numa_64_10M_L_OFF_3nd/
        NUMBER=3nd
	startMysql
        rwtest
        rotest
        wotest

	end_time=$(date +%s)  # 获取脚本结束时间（以秒为单位）
	# 计算脚本运行时间（以秒为单位）
	duration=$((end_time - start_time))
	echo "脚本运行时间：$duration 秒"
}
alltest

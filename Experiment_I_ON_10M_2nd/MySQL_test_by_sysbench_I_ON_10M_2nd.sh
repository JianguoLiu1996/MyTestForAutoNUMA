#!/bin/bash
OUTPUTPATH=/home/liujianguo/MyTestForAutoNUMA/Experiment_I_ON_10M_2nd/
function rwtest(){
	echo "==Prepare data for RW=="
	sysbench /home/liujianguo/Download/sysbench-1.0.11/tests/include/oltp_legacy/oltp.lua \
		--threads=20 \
		--oltp-table-size=10000000 \
		--oltp-tables-count=64 \
		--mysql-db=testdb \
		--db-driver=mysql \
		--mysql-host=localhost \
		--mysql-port=3306 \
		--mysql-user=root \
		--mysql-password=123456 \
		--report-interval=3 prepare >> "${OUTPUTPATH}mysysbench_rw_prepare_I_ON_10M_2nd_$(date +"%Y%m%d%H%M%S").log"
	
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
		--forced-shutdown=1 run >> "${OUTPUTPATH}mysysbench_rw_I_ON_10M_2nd_$(date +"%Y%m%d%H%M%S").log"
	echo "End time is: $(date '+%c')"

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
}

function rotest(){
	sleep 1m
	echo "==Prepare data for RO=="
	sysbench /home/liujianguo/Download/sysbench-1.0.11/tests/include/oltp_legacy/oltp.lua \
	 	--threads=20 \
	 	--oltp-table-size=10000000 \
	 	--oltp-tables-count=64 \
	 	--mysql-db=testdb \
	 	--db-driver=mysql \
	 	--mysql-host=localhost \
	 	--mysql-port=3306 \
	 	--mysql-user=root \
	 	--mysql-password=123456 \
	 	--report-interval=3 prepare >> "${OUTPUTPATH}mysysbench_ro_prepare_I_ON_10M_2nd_$(date +"%Y%m%d%H%M%S").log"

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
		--forced-shutdown=1 run >> "${OUTPUTPATH}mysysbench_ro_I_ON_10M_2nd_$(date +"%Y%m%d%H%M%S").log"
	echo "End time is: $(date '+%c')"
	
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
}

function wotest(){
	sleep 1m
	echo "==Prepare data for WO=="
	sysbench /home/liujianguo/Download/sysbench-1.0.11/tests/include/oltp_legacy/oltp.lua \
	 	--threads=20 \
	 	--oltp-table-size=10000000 \
	 	--oltp-tables-count=64 \
	 	--mysql-db=testdb \
	 	--db-driver=mysql \
	 	--mysql-host=localhost \
	 	--mysql-port=3306 \
	 	--mysql-user=root \
	 	--mysql-password=123456 \
	 	--report-interval=3 prepare >> "${OUTPUTPATH}mysysbench_wo_prepare_I_ON_10M_2nd_$(date +"%Y%m%d%H%M%S").log"
	
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
		--forced-shutdown=1 run >> "${OUTPUTPATH}mysysbench_wo_I_ON_10M_2nd_$(date +"%Y%m%d%H%M%S").log"
	echo "End time is: $(date '+%c')"

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
	echo "test end"
}

#start fuction
rwtest
sleep 1m
rotest
sleep 1m
wotest

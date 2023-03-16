#!/bin/bash
#echo "==Prepare data for RW=="
#sysbench /home/liujianguo/Download/sysbench-1.0.11/tests/include/oltp_legacy/oltp.lua \
#	--threads=20 \
#	--oltp-table-size=10000000 \
#	--oltp-tables-count=64 \
#	--mysql-db=testdb \
#	--db-driver=mysql \
#	--mysql-host=localhost \
#	--mysql-port=3306 \
#	--mysql-user=root \
#	--mysql-password=123456 \
#	--report-interval=3 prepare

#echo "==run sysbench for RW=="
#sysbench /home/liujianguo/Download/sysbench-1.0.11/tests/include/oltp_legacy/oltp.lua \
#	--threads=200 \
#	--time=1800 \
#	--max-requests=0 \
#	--mysql-db=testdb \
#	--oltp-table-size=10000000 \
#	--oltp-tables-count=64 \
#	--db-driver=mysql \
#	--mysql-host=localhost \
#	--mysql-port=3306 \
#	--mysql-user=root \
#	--mysql-password=123456 \
#	--report-interval=3 \
#	--forced-shutdown=1 run >> /home/liujianguo/MyTestForAutoNUMA/Experiment_I_OFF/mysysbench_rw_I_OFF_20230315.log

#echo "==cleanup sysbench testdb of RW=="
#sysbench /home/liujianguo/Download/sysbench-1.0.11/tests/include/oltp_legacy/oltp.lua \
#       --threads=200 \
#       --time=1800 \
#       --max-requests=0 \
#       --mysql-db=testdb \
#       --oltp-table-size=10000000 \
#       --oltp-tables-count=64 \
#       --db-driver=mysql \
#       --mysql-host=localhost \
#       --mysql-port=3306 \
#       --mysql-user=root \
#       --mysql-password=123456 \
#       --report-interval=3 \
#       --forced-shutdown=1 cleanup

#echo "==Prepare data for RO=="
#sysbench /home/liujianguo/Download/sysbench-1.0.11/tests/include/oltp_legacy/oltp.lua \
#       --threads=20 \
#       --oltp-table-size=10000000 \
#       --oltp-tables-count=64 \
#       --mysql-db=loadtest \
#       --db-driver=mysql \
#       --mysql-host=localhost \
#       --mysql-port=3306 \
#       --mysql-user=root \
#       --mysql-password=123456 \
#       --report-interval=3 prepare >> /home/liujianguo/MyTestForAutoNUMA/Experiment_I_OFF/mysysbench_ro_prepare_I_OFF_20230315.log

#echo "==run sysbench test for RO=="
#sysbench /home/liujianguo/Download/sysbench-1.0.11/tests/include/oltp_legacy/oltp.lua \
#	--mysql-host=localhost \
#	--oltp-tables-count=64 \
#	--mysql-user=root \
#	--mysql-password=123456 \
#	--mysql-port=3306 \
#	--db-driver=mysql \
#	--oltp-table-size=10000000 \
#	--mysql-db=loadtest \
#	--max-requests=0 \
#	--oltp-simple-ranges=0 \
#	--oltp-distinct-ranges=0 \
#	--oltp-sum-ranges=0 \
#	--oltp-order-ranges=0 \
#	--time=1800 \
#	--oltp-read-only=on \
#	--threads=200 \
#	--report-interval=3 \
#	--thread-init-timeout=300 \
#	--forced-shutdown=1 run >> /home/liujianguo/MyTestForAutoNUMA/Experiment_I_OFF/mysysbench_ro_I_OFF_20230315.log
#echo "ro test end"

#echo "==cleanup sysbench testdb for RO=="
#sysbench /home/liujianguo/Download/sysbench-1.0.11/tests/include/oltp_legacy/oltp.lua \
#        --mysql-host=localhost \
#        --oltp-tables-count=64 \
#        --mysql-user=root \
#        --mysql-password=123456 \
#        --mysql-port=3306 \
#        --db-driver=mysql \
#        --oltp-table-size=10000000 \
#        --mysql-db=loadtest \
#        --max-requests=0 \
#        --oltp-simple-ranges=0 \
#        --oltp-distinct-ranges=0 \
#        --oltp-sum-ranges=0 \
#        --oltp-order-ranges=0 \
#        --time=1800 \
#        --oltp-read-only=on \
#        --threads=200 \
#        --report-interval=3 \
#        --thread-init-timeout=300 \
#        --forced-shutdown=1 cleanup

#echo "==Prepare data for WO=="
#sysbench /home/liujianguo/Download/sysbench-1.0.11/tests/include/oltp_legacy/oltp.lua \
#       --threads=20 \
#       --oltp-table-size=10000000 \
#       --oltp-tables-count=64 \
#       --mysql-db=loadtest \
#       --db-driver=mysql \
#       --mysql-host=localhost \
#       --mysql-port=3306 \
#       --mysql-user=root \
#       --mysql-password=123456 \
#       --report-interval=3 prepare >> /home/liujianguo/MyTestForAutoNUMA/Experiment_I_OFF/mysysbench_wo_prepare_I_OFF_20230316.log

#echo "== run sysbench for WO=="
#sysbench /home/liujianguo/Download/sysbench-1.0.11/tests/include/oltp_legacy/oltp.lua \
#	--mysql-host=localhost \
#	--oltp-tables-count=64 \
#	--mysql-user=root \
#	--mysql-password=123456 \
#	--mysql-port=3306 \
#	--db-driver=mysql \
#	--oltp-table-size=10000000 \
#	--mysql-db=loadtest \
#	--max-requests=0 \
#	--max-time=1800 \
#	--oltp-simple-ranges=0 \
#	--oltp-distinct-ranges=0 \
#	--oltp-sum-ranges=0 \
#	--oltp-order-ranges=0 \
#	--oltp-point-selects=0 \
#	--threads=200 \
#	--randtype=uniform \
#	--report-interval=3 \
#	--thread-init-timeout=300 \
#	--forced-shutdown=1 run >> /home/liujianguo/MyTestForAutoNUMA/Experiment_I_OFF/mysysbench_wo_I_OFF_20230316.log
#echo "test for wo is end"

echo "== cleanup sysbench for WO"
sysbench /home/liujianguo/Download/sysbench-1.0.11/tests/include/oltp_legacy/oltp.lua \
       --mysql-host=localhost \
       --oltp-tables-count=64 \
       --mysql-user=root \
       --mysql-password=123456 \
       --mysql-port=3306 \
       --db-driver=mysql \
       --oltp-table-size=10000000 \
       --mysql-db=loadtest \
       --max-requests=0 \
       --max-time=1800 \
       --oltp-simple-ranges=0 \
       --oltp-distinct-ranges=0 \
       --mysql-host=localhost \
       --oltp-tables-count=64 \
       --mysql-user=root \
       --mysql-password=123456 \
       --mysql-port=3306 \
       --db-driver=mysql \
       --oltp-table-size=10000000 \
       --mysql-db=loadtest \
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

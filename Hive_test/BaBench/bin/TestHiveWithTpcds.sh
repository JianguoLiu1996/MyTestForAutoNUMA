#!/bin/bash

# configurations
dataFormat=parquet
dataScale=1
#selectedQueries=q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11,q12,q13,q14a,q14b,q15,q16,q17,q18,q19,q20,q21,q22,q23a,q23b,q24a,q24b,q25,q26,q27,q28,q29,q30,q31,q32,q33,q34,q35,q36,q37,q38,q39a,q39b,q40,q41,q42,q43,q44,q45,q46,q47,q48,q49,q50,q51,q52,q53,q54,q55,q56,q57,q58,q59,q60,q61,q62,q63,q64,q65,q66,q67,q68,q69,q70,q71,q72,q73,q74,q75,q76,q77,q78,q79,q80,q81,q82,q83,q84,q85,q86,q87,q88,q89,q90,q91,q92,q93,q94,q95,q96,q97,q98,q99
selectedQueries=q91


# submit benchmark program
#if hadoop fs -test -e /BenchmarkData/Tpcds/tpcds_${dataScale}/tpcds_${dataFormat}/web_site;then
if hadoop fs -test -e /BenchmarkData/Tpcds/tpcds_${dataScale}/web_site;then

location=$(cd "$(dirname "$0")";pwd)
querys=(`echo $selectedQueries | tr ',' ' '`)
durations=()
durationSum=0

function timediff() {
    # time format:date +"%s.%N"
    start_time=$1
    end_time=$2

    start_s=${start_time%.*}
    start_nanos=${start_time#*.}
    end_s=${end_time%.*}
    end_nanos=${end_time#*.}

    # end_nanos > start_nanos?
    # Another way, the time part may start with 0, which means
    # it will be regarded as oct format, use "10#" to ensure
    # calculateing with decimal
    if [ "$end_nanos" -lt "$start_nanos" ];then
        end_s=$(( 10#$end_s - 1 ))
        end_nanos=$(( 10#$end_nanos + 10**9 ))
    fi

    # get timediff
    time=$(( 10#$end_s - 10#$start_s )).`printf "%03d\n" $(( (10#$end_nanos - 10#$start_nanos)/10**6 ))`
    typeset time=$(echo "scale=3;$time * 1000" | bc)
    echo $time | awk -F. '{print $1}'
}

function runHive() {
  #hive -i $location/../querySamples/tpcds/init.sql --database tpcds_$1_$2 -f $location/../querySamples/tpcds/$3
  #hive -u "jdbc:hive2://192.168.1.2:10000" -n root -p 123456 -i $location/../querySamples/tpcds/init.sql -database tpcds_$1_$2 -f $location/../querySamples/tpcds/$3
  hive -u "jdbc:hive2://192.168.1.2:10000" -n root -p 123456 -i $location/../querySamples/tpcds/init.sql -f $location/../querySamples/tpcds/$3
}
startTime=`date +'%Y-%m-%d_%H:%M:%S'`

for i in "${!querys[@]}";do
    startSecondsQuery=$(date +%s.%N)
    runHive $dataScale $dataFormat ${querys[$i]}.sql
    if [ "$?" -ne 0 ];then
      echo "Falied: Hive ${dataScale}GB Tpcds test failed at Query ${querys[$i]}."
      exit 1
    fi
    endSecondsQuery=$(date +%s.%N)
    durations[$i]=$(timediff $startSecondsQuery $endSecondsQuery)
    durationSum=$((durationSum+durations[$i]))
done

endTime=`date +'%Y-%m-%d_%H:%M:%S'`

else
   echo "${dataScale}GB Tpcds data does not exist in HDFS or has broken. Please re-generate it before testing."
   exit 1
fi

echo "Hive  Tpcds  (${querys[*]})  (${durations[*]})  $startTime  $endTime  $durationSum  $dataScale  $dataFormat  Succeed" >> $location/../reports/babench.report

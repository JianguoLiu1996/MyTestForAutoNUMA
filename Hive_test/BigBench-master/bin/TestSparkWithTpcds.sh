#!/bin/bash

# configurations
dataScale=10
#datascale=1
#selectedQueries=q1,q2,q3
selectedQueries=q1,q2,q3,q4,q5,q6,q7,q8,q9,q10,q11,q12,q13,q14a,q14b,q15,q16,q17,q18,q19,q20,q21,q22,q23a,q23b,q24a,q24b,q25,q26,q27,q28,q29,q30,q31,q32,q33,q34,q35,q36,q37,q38,q39a,q39b,q40,q41,q42,q43,q44,q45,q46,q47,q48,q49,q50,q51,q52,q53,q54,q55,q56,q57,q58,q59,q60,q61,q62,q63,q64,q65,q66,q67,q68,q69,q70,q71,q72,q73,q74,q75,q76,q77,q78,q79,q80,q81,q82,q83,q84,q85,q86,q87,q88,q89,q90,q91,q92,q93,q94,q95,q96,q97,q98,q99

# submit benchmark program
if hadoop fs -test -e /BenchmarkData/Tpcds/tpcds_${dataScale}/web_site;then
location=$(cd "$(dirname "$0")";pwd)
# spark-submit --class <class> <JAR_PATH> <DATA_SCALE> <QUERY_LIST> <REPORT_LOCATION> <HADOOP_HOST>
spark-submit --class org.shuhai.spark.sql.perf.tpcds.RunTpcds ${location}/../jars/BenchmarkSuites.jar \
$dataScale \
$selectedQueries \
${location}/../Reports \
$HOSTNAME

else
   echo "${dataScale}GB Tpcds data does not exist in HDFS or has broken. Please re-generate it before testing."
   exit 1
fi



#!/bin/bash

# start hadoop
start-dfs.sh
start-yarn.sh

location=$(cd "$(dirname "$0")";pwd)
cd $location/../tools/tpcds-kit/tools/ && make
cd $location/../tools/tpch-kit/dbgen && make



#!/bin/bash

set -e

echo "===== SYSTEM INFO ====="
lscpu || sysctl -a | grep machdep.cpu
free -h || vm_stat
lsblk || df -h

echo "===== CPU BENCHMARK ====="
sysbench cpu --cpu-max-prime=10000 run

echo "===== MEMORY BENCHMARK ====="
sysbench memory --memory-block-size=1M --memory-total-size=2G run

echo "===== DISK BENCHMARK ====="

OS=$(uname)

if [[ "$OS" == "Linux" ]]; then
  IOENGINE="libaio"
  DIRECT="--direct=1"
elif [[ "$OS" == "Darwin" ]]; then
  IOENGINE="posixaio"
  DIRECT=""
else
  IOENGINE="sync"
  DIRECT=""
fi

echo "Using fio ioengine: $IOENGINE"

fio --name=disk-test \
    --filename=fio-test.tmp \
    --size=256M \
    --rw=readwrite \
    --bs=4k \
    --ioengine=$IOENGINE \
    $DIRECT \
    --numjobs=1 \
    --runtime=30 \
    --group_reporting

rm -f fio-test.tmp


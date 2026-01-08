#!/bin/bash

echo "===== SYSTEM INFO ====="
lscpu
free -h
lsblk

echo "===== CPU BENCHMARK ====="
sysbench cpu --cpu-max-prime=10000 run

echo "===== MEMORY BENCHMARK ====="
sysbench memory --memory-block-size=1M --memory-total-size=2G run

echo "===== DISK BENCHMARK ====="
fio --name=disk-test \
    --filename=fio-test.tmp \
    --size=256M \
    --rw=readwrite \
    --bs=4k \
    --ioengine=libaio \
    --direct=1 \
    --numjobs=1 \
    --runtime=30 \
    --group_reporting

rm fio-test.tmp

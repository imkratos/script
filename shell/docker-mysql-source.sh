#!/bin/bash

# MySQL连接信息
MYSQL_HOST="localhost"
MYSQL_PORT="3306"
MYSQL_USER="root"
MYSQL_PASSWORD="123456"
MYSQL_DATABASE="mysql"

# 数据文件路径
DATA_FILE=/data/mysql/xxx.sql

# 导入数据
mysql -h $MYSQL_HOST -P $MYSQL_PORT -u $MYSQL_USER -p$MYSQL_PASSWORD $MYSQL_DATABASE < $DATA_FILE

rm -rf $DATA_FILE

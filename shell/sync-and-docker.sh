#!/bin/bash

rm -rf ./done.txt
scp -P port root@ip:/data/mysql/backup/xxx.sql /home/shuoshuo/mysql/

sed -i 's/utf8mb4_0900_ai_ci/utf8mb4_general_ci/g' /home/shuoshuo/mysql/chatgpt_web_plus-curday.sql

#docker import data
sudo docker exec mysql sh -c 'sh /data/mysql/source_data.sh'

echo "sync done"

touch done.txt

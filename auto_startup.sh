#!/bin/bash

echo "auto startup at $(date)" >> /data/logs/auto_startup_log.log
source /etc/profile
#elasticsearch
su - elk<<!
cd /data/ent/elastic/elasticsearch-5.6.0
./bin/elasticsearch -d
exit
!
#logstash
cd /data/ent/elastic/logstash-5.6.0
nohup ./bin/logstash -f config/conf.d/ &
#kibana
cd /data/ent/elastic/kibana-5.6.0
nohup ./bin/kibana &

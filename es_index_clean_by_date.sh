#!/bin/bash

###################################
#删除早于n天的ES集群的索引
#
#@author: huangwh
#@date:2018-10-25 
###################################
es_addr=172.168.50.84
log_dir=/data/logs/elastic/es_index_clean_by_date.log
log_err_dir=/data/logs/elastic/es_index_clean_by_date.err.log
end_day=2

function delete_indices() {
    comp_date=`date -d "$end_day day ago" +"%Y-%m-%d"`
    date1="$1 00:00:00"
    date2="$comp_date 00:00:00"
    curdate=`date`
    t1=`date -d "$date1" +%s` 
    t2=`date -d "$date2" +%s` 

    if [ $t1 -le $t2 ]; then
        echo "$1时间早于$comp_date，进行索引删除" >> $log_dir
        #转换一下格式，将类似yyyy-mm-dd格式转化为yyyy.mm.dd
        format_date=`echo $1| sed 's/-/\./g'`
        curl -XDELETE "http://$es_addr:9200/*$format_date"

	if [ $? -eq 0 ];then
                echo "$curdate -->del $format_date log success.." >> $log_dir
        else
                echo "$curdate -->del $format_date log fail.." >> $log_dir
        fi

    fi
}

curl -XGET "http://$es_addr:9200/_cat/indices" | awk -F" " '{print $3}' | awk -F"-" '{print $NF}' | egrep "[0-9]*\.[0-9]*\.[0-9]*" | sort | uniq  | sed 's/\./-/g' | while read LINE
do
    #调用索引删除函数
    delete_indices $LINE
done

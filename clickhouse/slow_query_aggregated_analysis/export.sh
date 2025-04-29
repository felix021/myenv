#!/bin/bash

cd `dirname $0`

host=127.0.0.1
username=default
password=12345678

file=query_log

begin=$1
end=$2

if [ -z "$begin" -o -z "$end" ]; then
	echo "Usage: $0 <BEGIN_TIME> <END_TIME>"
	exit 1
fi

echo "导出 $begin ~ $end 的查询..."

set -x

clickhouse client --host $host --user $username --password $password --query "
  select
    query_start_time,
    query_duration_ms / 1000 as duration_second,
    memory_usage,
    ProfileEvents.Values[indexOf(ProfileEvents.Names, 'UserTimeMicroseconds')] AS user_cpu,
    read_rows,
    read_bytes,
    written_rows,
    written_bytes,
    query
  from system.query_log
  where query_start_time between '$begin' and '$end'
    and type = 'QueryFinish'
    and arrayExists(x -> x LIKE '\''system.%'\'', tables) != 1
  order by query_start_time

  FORMAT TabSeparatedWithNames;
" > $file
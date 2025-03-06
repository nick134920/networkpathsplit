#!/bin/sh
mkdir -p ./pbr
cd ./pbr

wget --no-check-certificate -c -O CN.txt https://metowolf.github.io/iplist/data/special/china.txt

# 获取ASN37963的IP段
wget --no-check-certificate -c -O asn37963.json "https://stat.ripe.net/data/announced-prefixes/data.json?resource=AS37963"

# 提取IPv4前缀
grep -o '"prefix":"[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+/[0-9]\+"' asn37963.json | sed 's/"prefix":"//g' | sed 's/"//g' > asn37963.txt

# 合并IP段
cat CN.txt asn37963.txt | sort | uniq > merged.txt

{
echo "/ip firewall address-list"

for net in $(cat merged.txt) ; do
  echo "add list=CN address=$net"
done

} > ../CN.rsc

cd ..
rm -rf ./pbr

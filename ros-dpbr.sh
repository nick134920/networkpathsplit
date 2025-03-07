#!/bin/sh
mkdir -p ./pbr
cd ./pbr

wget --no-check-certificate -c -O CN.txt https://metowolf.github.io/iplist/data/special/china.txt

echo "" >> CN.txt

curl -s "https://stat.ripe.net/data/announced-prefixes/data.json?resource=AS37963" | jq -r '.data.prefixes[].prefix | select(test("^\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}\\.\\d{1,3}/\\d{1,2}$"))' > asn37963.txt


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

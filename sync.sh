#!/bin/bash
# author: gfw-breaker

folder="pokong"
#stick="gDaf0eGjyw4"
#stick="UefWtTqAH_M"
youtube_url=https://www.youtube.com/channel/UCwb7avxK-L5vPjMC1ZIGayw
dl_script=https://raw.githubusercontent.com/gfw-breaker/youtube-video/master/dl.sh
md_page=/usr/share/nginx/html/$folder/index.md


# download
cd /root/$folder
wget -q $dl_script -O dl.sh
bash dl.sh $folder $youtube_url $stick


# push
cd /root/$folder
git pull
sed -i '5,$d' README.md
cat $md_page >> README.md
git commit -a -m 'ok'
git push



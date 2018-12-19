#!/bin/bash
# author: gfw-breaker

folder="wenzhao"
stick="NUZukGNZv6k"
#stick="kA52M-Hxi9I"
#stick="UefWtTqAH_M"
youtube_url=https://www.youtube.com/channel/UCtAIPjABiQD3qjlEl1T5VpA
dl_script=https://raw.githubusercontent.com/gfw-breaker/youtube-video/master/dl.sh


# download
cd /root/$folder
wget -q $dl_script -O dl.sh
bash dl.sh -f $folder -u $youtube_url -s $stick 





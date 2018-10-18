#!/bin/bash
# author: gfw-breaker

if [ $# -eq 1 ]; then
	video_count=$1
else
	video_count=2
fi

video_dir=/usr/share/nginx/html/wenzhao
index_page=$video_dir/index.html
md_page=$video_dir/index.md
youtube_url=https://www.youtube.com/playlist?list=PL2DywIam67jsFoEhIvVhB0HukSP8IAIt0

ip=$(/sbin/ifconfig | grep "inet addr" | sed -n 1p | cut -d':' -f2 | cut -d' ' -f1)
ts=$(date '+%m%d%H')


# download videos
cd $video_dir
youtube-dl -f 18 \
	--max-downloads $video_count \
	-i $youtube_url


# generate page
echo > $md_page
cat > $index_page << EOF
<html>
<head>
<meta charset="utf-8" /> 
</head>
<body>
EOF

for v in $(ls -t *.mp4); do
	name=$(echo $v | sed "s/'//g" | sed "s/ /_/g" | sed "s/%/百分点/g")
	mv $v $name > /dev/null 2>&1
done

for v in $(ls -t *.mp4); do
	title=$(echo $v | cut -d'-' -f1)
	name=$v
	af=$(echo $name | sed 's/mp4/mp3/')
	echo "<a href='http://$ip/wenzhao/$name.html?t=$ts'><b>$title</b></a></br></br>" >> $index_page
	echo "##### <a href='http://$ip/wenzhao/$name.html?t=$ts'>$title</a>" >> $md_page
	cat > $video_dir/$name.html << EOF
<head>
<title>《文昭谈古论今》- $title </title>
<meta charset="UTF-8"> 
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<link rel='stylesheet' id='videojs-css' href='https://unpkg.com/video.js@6.7.3/dist/video-js.min.css' type='text/css' media='all' />
<style>
#player {
	margin: 0 auto;
	margin-top: 20px;
	width: 100%;
	max-width: 640px;
}
</style>
</head>
<br/>
<h4><center>$title</center></h4>
<center>
<video id="player" controls autoplay preload="auto">
	<source src="$name?t=$ts" type="video/mp4">
</video>
<p>
<a href="http://$ip:8000/xtr/gb/prog832.html"><b>文昭新唐人座客节目《热点解读》</b></a>&nbsp;&nbsp;
<a href="https://github.com/gfw-breaker/nogfw/blob/master/README.md" target="_blank"><b> 一键翻墙软件</b></a>
<!--<a href="$af?t=$ts"><b>下载音频</b></a>--><br/><br/>
<a href="http://$ip:10080/gb/8/11/24/n2339512.htm"><b>文昭：生活在希望中，做快乐的中国人</b></a><br/><br/>
<a href="http://$ip:10000/videos/blog/tuid.html"><b>三退大潮席卷全球 三亿人觉醒见证中共末日</b></a><br/><br/>
<a href="http://$ip:10000/videos/jiuping/index.html"><b>《九评共产党》</b></a>&nbsp;&nbsp;
<a href="http://$ip:10000/videos/mtdwh/index.html"><b>《漫谈党文化》</b></a>&nbsp;&nbsp;
<a href="http://$ip:8000/xtr/gb/prog99.html"><b>《热点互动直播》</b></a>&nbsp;&nbsp;
<a href="http://$ip:8000/xtr/gb/prog109.html"><b>《大陆新闻解读》</b></a>&nbsp;&nbsp;<br/><br/>
<a href="http://$ip:10000/videos/blog/weihuo.html"><b>天安门自焚真相《伪火》</b></a>&nbsp;&nbsp;
<a href="http://$ip:10000/videos/legend/2.html"><b>“四‧二五”中南海万人上访真相</b></a>&nbsp;&nbsp;<br/><br/>
</center></p>
</center></p>
</center></p>
EOF

done
echo "</body></html>" >> $index_page


# commit
plinks="##### 反向代理： [Google](http://$ip:8888/search?q=425事件) - [维基百科](http://$ip:8100/wiki/喬高-麥塔斯調查報告) - [大纪元新闻网](http://$ip:10080) - [新唐人电视台](http://$ip:8000) - [希望之声](http://$ip:8200) - [神韵艺术团](http://$ip:8000/xtr/gb/prog673.html) - [我的博客](http://$ip:10000/)"
vlinks="##### 精彩视频： [《时事小品》](https://github.com/gfw-breaker/ntdtv-comedy/blob/master/README.md) - [《传奇时代》](http://$ip:10000/videos/legend/) - [《风雨天地行》](http://$ip:10000/videos/fytdx/) - [《九评共产党》](http://$ip:10000/videos/jiuping/) - [《漫谈党文化》](http://$ip:10000/videos/mtdwh/) - [709维权律师](http://$ip:10000/videos/709/)"
cd /root/wenzhao
git pull
sed -i '5,$d' README.md
cat $md_page >> README.md
sed -i "8 a$vlinks" README.md
sed -i "8 a$plinks" README.md
git commit -a -m 'ok'
git push


# convert audio
#cd $video_dir 
#for v in $(ls -t *.mp4); do
#	a=$(echo $v | sed 's/mp4/mp3/')	
#	if [ -f $a ]; then
#		echo 'ok'
#	else
#		ffmpeg -i $v -b:a 64K -vn $a
#	fi
#done


使用 phantomjs 来将 js charts 转换为图片

1. echarts-export
echarts 转换为 png

phantomjs echarts-export.js -infile options -outfile out.png -width 800 -height 400

options 是一个echarts 的 js 配置文件

2. highcharts-export-server 是 highcharts 官方提供的 phantomjs 脚本


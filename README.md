# DoubanMovie
主要是用来练习MVVM + RAC,数据来自豆瓣API（已经不开放了，但是接口依然可以调用）。Demo调用了豆瓣电影，豆瓣音乐和豆瓣读书的API，内容详情使用WebView加载（为了偷懒）。

# 实现效果
![](https://ws2.sinaimg.cn/large/006tKfTcly1g0tx7gzfjag309i0jfb2d.gif)
# 文件夹结构
![](https://ws2.sinaimg.cn/large/006tKfTcly1g0tx0btfdxj30ic11wn5p.jpg)

按照MVVM的惯例，多了一个ViewModel的文件夹。将原本是C中的网络请求、数据处理等操作移到了这个文件内。

**有个比较严重的问题**：本人对MVVM的精髓掌握不够，没有完全解耦View和Model。如果有哪位大佬有好的办法，请[联系我](idoghuan@163.com)。

[源码地址](https://github.com/BigPoro/DoubanMovie)


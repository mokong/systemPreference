# systemPreference
方便跳转的小工具，例如从通知中心直接跳转到系统蜂窝数据开关界面，等等

![Aaron Swartz](http://tango.blob.core.chinacloudapi.cn/images/20151210174207.gif)

1. 支持自定义，可以添加自己想要的入口至通知中心，只需要在json文件里添加对应的prefs即可，在程序里有查找的地方

2. 添加长按拖动cell，参考这篇博客[利用长按手势移动 Table View Cells](http://beyondvincent.com/2014/03/26/2014-03-26-cookbook-moving-table-view-cells-with-a-long-press-gesture/)

3. 添加图标对应图片

4. 去除自定义Button，由button的titleEdgeInsets和imageEdgeInsets实现文字图片的上下排列，参考这篇博客[如何布局包含Image和Title的UIButton](http://victorchee.github.io/blog/button-layout-with-image-and-title/)

## 使用的技术
1. 使用CocoaPod引入YYModel, 所以如果下载下来不能用的话，可以试一下重新Pod install
2. 使用Group实现today Extension与程序的通信
3. 使用Masonry自定义文字、图片上下排列的按钮
4. 用titleEdgeInsets和imageEdgeInsets实现文字、图片上下排列


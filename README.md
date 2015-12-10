# systemPreference
方便跳转的小工具，例如从通知中心直接跳转到系统蜂窝数据开关界面，等等

![Aaron Swartz](http://tango.blob.core.chinacloudapi.cn/images/20151210174207.gif)

1. 支持自定义，可以添加自己想要的入口至通知中心，只需要在json文件里添加对应的prefs即可，在程序里有查找的地方

2. 后续的话，打算添加一个好看的icon，同时再json文件里添加image属性，不同的入口对应不同的图标（现在是只有这三个。。。），欢迎大家修改，本来打算用collectionView实现拖动，后来发现好像比较麻烦，找了个第三方还没看。如果大家有实现的，请给我一份，谢谢啦

## 使用的技术
1. 使用CocoaPod引入YYModel, 所以如果下载下来不能用的话，可以试一下重新Pod install
2. 使用Group实现today Extension与程序的通信



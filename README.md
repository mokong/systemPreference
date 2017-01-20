# systemPreference
方便跳转的小工具，例如从通知中心直接跳转到系统蜂窝数据开关界面，等等


## 更新
> 修改iOS10跳转不成功的问题

> Note：之前iOS10跳转失败之后，没找到如何跳转，前两天下了个APP，发现iOS10竟然也可以跳转，就查找了一下，顺便更新一下

### 应用内直接跳转具体设置界面： 

1. iOS 9 8 7  的跳转  
	eg:  
	
		NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
		if ([[UIApplication sharedApplication] canOpenURL:url]) {  
			[[UIApplication sharedApplication] openURL:url]; // iOS 9 的跳转
		}

	这个跳转方法在iOS10下不生效
	
2. iOS 10 的跳转，可使用MobileCoreServices.framework里的私有API，WiFi钥匙等都是这么做的，可通过混淆私有API的方法绕过审核，但是有被下架的风险。  
	eg:  
		
		导入MobileCoreServices.framework框架
		#import <MobileCoreServices/MobileCoreServices.h>
		// Prefs:root=WIFI P要大写
		NSURL *url = [NSURL URLWithString:@"Prefs:root=WIFI"];
		Class LSApplicationWorkspace = NSClassFromString(@"LSApplicationWorkspace");
		[[LSApplicationWorkspace performSelector:@selector(defaultWorkspace)] performSelector:@selector(openSensitiveURL:withOptions:) withObject:url withObject:nil];

### 直接跳转到**当前应用**设置界面的方法  
	eg:  
	
		NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
		if ([[UIApplication sharedApplication] canOpenURL:url]) {
		    [[UIApplication sharedApplication] openURL:url];
		}
		
### 通知栏跳转具体设置界面
通知栏应用（AirLaunch，Launcher），跳转方法和iOS 10之前一样，但是需要将prefs改为Prefs  
	eg:  
			
		NSURL *url;
		if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0) {
			url = [NSURL URLWithString:[NSString stringWithFormat:@"Prefs:root=%@", targetItem.prefs]];
    	}
    	else {
			url = [NSURL URLWithString:[NSString stringWithFormat:@"prefs:root=%@", targetItem.prefs]];
		}
		[self.extensionContext openURL:url completionHandler:nil];



参考: [聊聊iOS 10更新以后跳转系统设置的几种方式](https://segmentfault.com/a/1190000007097444)




![Aaron Swartz](http://tango.blob.core.chinacloudapi.cn/images/20151210174207.gif)

1. 支持自定义，可以添加自己想要的入口至通知中心，只需要在json文件里添加对应的prefs即可，在程序里有查找的地方

2. 添加长按拖动cell，参考这篇博客[利用长按手势移动 Table View Cells](http://beyondvincent.com/2014/03/26/2014-03-26-cookbook-moving-table-view-cells-with-a-long-press-gesture/)

3. 添加图标对应图片

4. 去除自定义Button，由button的titleEdgeInsets和imageEdgeInsets实现文字图片的上下排列，参考这篇博客[如何布局包含Image和Title的UIButton](http://victorchee.github.io/blog/button-layout-with-image-and-title/)
5. **注意:** 如果用xib的话，必须给button的图片和按钮初始化的内容，否则会发现图片显示不出来；


## 使用的技术
1. 使用CocoaPod引入YYModel, 所以如果下载下来不能用的话，可以试一下重新Pod install
2. 使用Group实现today Extension与程序的通信
3. 使用Masonry自定义文字、图片上下排列的按钮
4. 用titleEdgeInsets和imageEdgeInsets实现文字、图片上下排列


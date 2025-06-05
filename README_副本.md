
# Toast For Swift


## 概要说明

**MCToast** 是Swift版本的HUD库，提供了显示纯文本的Toast，带有状态图片的Toast，带有loading样式的Toast。
![Toast.gif](https://upload-images.jianshu.io/upload_images/3424061-20f13f467069cc45.gif?imageMogr2/auto-orient/strip)


主要优点：

* Swift语言实现的Toast交互功能库。
* MCToast内部控制显示在主线程中，保证了线程安全性。
* 提供了多种使用方式，方便快捷。
* **支持UI的高度自定义**。配置toast的小图标，文字大小和颜色等
* 内部处理了多个toast提示重叠显示的问题。



Demo地址

[https://github.com/mancongiOS/MCToast](https://github.com/mancongiOS/MCToast)
 


# 配置
MCToast已经提供了一套默认值，如果与您的要求不相符，您完全可以根据以下方法通配它。
  
在`func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool`中进行配置项的设置。

```
extension AppDelegate {
    func configToast() {
        // 1. 配置Toast弹出过程中的交互类型（MCToastRespond：禁止交互，导航栏下禁止交互，允许交互）
        MCToastConfig.shared.respond = MCToast.MCToastRespond.respond
        
  
        // 2. 配置Toast核心区域（黑色区域）
        // 颜色
        MCToastConfig.shared.background.color = UIColor.black
        // 大小
        MCToastConfig.shared.background.size = CGSize(width: 120, height: 120)
        
        
        // 3. 配置状态Toast（成功，失败，警告等状态）的Icon
        MCToastConfig.shared.icon.size = CGSize(width: 50, height: 50)
        MCToastConfig.shared.icon.successImage = UIImage(named: "你成功状态的Icon")
        MCToastConfig.shared.icon.failureImage = UIImage(named: "你失败状态的Icon")
        MCToastConfig.shared.icon.warningImage = UIImage(named: "你警告状态的Icon")

        
        // 4. 配置文字
        MCToastConfig.shared.text.font = UIFont.systemFont(ofSize: 15)
        MCToastConfig.shared.text.textColor = UIColor.white
        MCToastConfig.shared.text.offset = (UIScreen.main.bounds.size.height / 2 - 120 - 150)
        
        
        // 5. 配置间距
        // 外边距（toast距离屏幕边的最小边距
        MCToastConfig.shared.spacing.margin = 55
        // 内边距（toast和其中的内容的最小边距）
        MCToastConfig.shared.spacing.padding = 15
        
        
        // 6. 设置自动隐藏的时长
        MCToastConfig.shared.duration = 1.5
    }
}
```


# 使用
#### 支持cocoPods

  ```
  pod 'MCToast'
  ```


#### 使用

* 显示纯文本

```
extension MCToast {
    /// 展示文字toast
    /// - Parameters:
    ///   - text: 文字内容
    ///   - offset: 距离屏幕Y轴中心的距离（正下，负上）
    ///   - duration: 显示的时间（秒）
    ///   - respond: 交互类型
    ///   - callback: 隐藏的回调
    public static func mc_text(_ text: String,
                               offset: CGFloat? = nil,
                               duration: CGFloat = MCToastConfig.shared.duration,
                               respond: MCToast.MCToastRespond = MCToastConfig.shared.respond,
                               callback: MCToast.MCToastCallback? = nil) {
        
        DispatchQueue.main.async {
            MCToast.showText(text, offset: offset, duration: duration, respond: respond, callback: callback)
        }
    }
}
```

  ```
// 简单使用
MCToast.mc_text("修改成功")
 // 长文本的换行使用
MCToast.mc_text("这是一个很长长长长长长长长长长长长长长长的纯文本的展示")
// 设置文本的偏移量。（以屏幕中心点为原点，正下负上）
MCToast.mc_text("居中显示", offset: 0)
// 全量设置
MCToast.mc_text("设置成功", offset: 100, duration: 2, respond: .default) {
   print("移除了")
}
```

* 带状态的Toast

 ```
  /// 成功的Toast
  MCToast.mc_success("可能出现的长文本提示长文本内容")
  /// 失败的Toast
  MCToast.mc_failure("失败")
  /// 警告的Toast
  MCToast.mc_warning("警告")
  /// 自定义的状态Toast
  MCToast.mc_codeSuccess()
  extension MCToast {
      /// 发送验证码成功
      public static func mc_codeSuccess() {
          let image = UIImage.init(named: "codesend")
          MCToast.showStatus(nil, text: "发送验证码成功", iconImage: image, duration: 2, respond: .respond)
      }
  }
```

* loading
```
  /// 系统的loading
  MCToast.mc_loading()
  /// 自定义的帧动画loading
  MCToast.mc_loading(imageNames: images)
  /// Json动画的loading （集成了Lottie库）
  let animation = Animation.named("JSON动画")
  MCToast.mc_loading(animation: animation) 
  ```


* 您也可以直接用self调用。
作者通过给`UIResponder `添加扩展，达到了使用`self`调用的功能。
```
extension UIResponder { }
```
```
self.mc_text("这是一个纯文本的展示", duration: 2)
self.mc_statusBar("有内容更新啦，赶紧看看吧")
```

* 隐藏
```
// 调用的时候，通过设置展示时间，隐藏
self.mc_text("这是一个纯文本的展示", duration: 2)
// 通过其他方法隐藏
self.mc_remove() 
// 或者 MCToast.mc_remove()
```


* 其他更详细的使用请查看[Demo](https://github.com/mancongiOS/MCToast)






# 说明
1. 由于Toast是展示在Window上的，页面返回正在显示的Toast并不会消失。可以在页面的生命周期内调用MCToast.mc_remove()方法达到页面返回消失的目的。


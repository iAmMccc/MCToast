
# MCToast - Toast For Swift

<table>
<tr>
<td width="20%">
  <img src="https://github.com/iAmMccc/MCToast/blob/master/gif1-min.gif" width="100%">
</td>
<td width="100%">
  <strong>MCToast</strong> 
    <p>一个轻量、灵活、现代化的 Toast 组件，支持图标、文本、加载、状态栏提示等多种样式，具备键盘避让、响应策略、链式调用等能力，适用于 iOS 应用快速提示交互场景。</p>
  <strong>特性</strong>
  <ul>
    <li>支持文字、图标+文字、加载、状态栏提示等样式</li>
    <li>自动适配键盘弹出，避免 Toast 被遮挡</li>
    <li>支持自动消失、手动关闭、响应遮挡策略</li>
    <li>可设置回调：展示完成、隐藏完成</li>
    <li>链式调用结构，配置灵活优雅</li>
    <li>支持横竖屏切换</li>
  </ul>
</td>
</tr>
</table>



## 安装方式

**CocoaPods**

```
pod 'MCToast'
```



## 使用方法

### 显示Toast

| 风格             | 代码展示                                       |
| ---------------- | ---------------------------------------------- |
| 纯文本风格       | ``` MCToast.plainText("提示文案")```           |
| 带状态icon的风格 | ```MCToast.iconText("成功", icon: .success)``` |
| 加载中风格       | ```MCToast.loadingText("加载中...")```         |
| 自定义UI风格     | ```MCToast.custom(customView)```               |
| 顶部显示风格     | ```MCToast.statusBarView(customView)```        |



### 配置Toast

支持配置 **隐藏时间**、 **响应策略**、 **显示回调**和 **隐藏回调**。

```
MCToast.plainText("加载成功")
    .duration(2)
    .respond(.allow)
    .showHandler {
        print("开始显示了")
    }
    .dismissHandler {
        print("Toast 隐藏了")
    }
```



### 隐藏Toast

```
MCToast.remove()
```



## 全局配置
MCToast已经提供了一套默认UI，你也可以自主配置它。

```
public struct MCToastConfig {
    public static var shared = MCToastConfig()
    
    /// 设置交互区域 默认导航栏下禁止交互
    public var respond = MCToast.RespondPolicy.allow
    
    /// 背景的设置
    public var background = Background()
    
    /// 状态Icon的设置
    public var icon = Icon()
    
    /// 文本的设置
    public var text = Text()
    
    /// 自动隐藏的时长
    public var duration: CGFloat = 1.8
}


extension MCToastConfig {
    public struct Background {
        /// toast 的背景颜色
        public var color: UIColor = UIColor.black.withAlphaComponent(0.9)
        public var colorAlpha: CGFloat = 0.8
        
        var resolvedColor: UIColor {
            color.withAlphaComponent(colorAlpha)
        }
    }
    
    public struct Icon {
        /// icon类型的toast的宽度，高度根据文字动态计算
        public var toastWidth: CGFloat = 160
        /// 内边距（toast和其中的内容的最小边距）
        public var padding: UIEdgeInsets = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        /// 圆角
        public var cornerRadius: CGFloat = 8
        /// 图片size
        public var imageSize: CGSize = CGSize.init(width: 50, height: 50)
        
        /// 自定义成功的icon
        public var successImage: UIImage?
        /// 自定义失败的icon
        public var failureImage: UIImage?
        /// 自定义警告的icon
        public var warningImage: UIImage?
        
        public var textColor: UIColor = UIColor.white
        public var font: UIFont = UIFont.systemFont(ofSize: 14)
    }
    
    public struct Text {
        public var textColor: UIColor = UIColor.white
        public var font: UIFont = UIFont.systemFont(ofSize: 14)
        /// 圆角
        public var cornerRadius: CGFloat = 4
        /// 内边距（toast和其中的内容的最小边距）
        public var padding: UIEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        
        /// 文字的最大宽度 （最大宽度 + 内边距 = toast的宽度）
        public var maxWidth: CGFloat = 224
        /// 文字的最小宽度 （最小宽度 + 内边距 = toast的宽度）
        public var minWidth: CGFloat = 88
        
        /// 横竖屏配置
        public var landscapeTextOffset: CGFloat = 60
        public var portraitTextOffset: CGFloat = 118
        public var avoidKeyboardOffsetY: CGFloat = 40
        /// toast底部距离屏幕底部距离
        public var offset: CGFloat {
            let isLandscape = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape ?? false
            if isLandscape {
                return landscapeTextOffset
            } else {
                return portraitTextOffset
            }
        }
    }
}
```



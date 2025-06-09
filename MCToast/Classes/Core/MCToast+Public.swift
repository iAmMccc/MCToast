//
//  Toast+Public.swift
//  MCToast
//
//  Created by qixin on 2025/6/9.
//

import Foundation
extension MCToast {
    /// 开启键盘适配功能，Toast 会自动避让键盘位置。
    /// 推荐在 App 启动或页面初始化时调用。
    public static func enableKeyboardTracking() {
        KeyboardManager.shared.keyboardHeightChanged = { keyboardHeight, duration in
            shared.onKeyboardWillChangeFrame(height: keyboardHeight, duration: duration)
        }
    }

    /// 开启横竖屏方向变化监听，Toast 会在设备旋转时自动调整布局。
    /// 推荐在 App 启动或页面初始化时调用。
    public static func enableOrientationTracking() {
        NotificationCenter.default.addObserver(shared, selector: #selector(onOrientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
}

extension MCToast {
    /// 移除当前正在显示的 Toast。
    /// - Parameter dismissHandler: 可选的回调，在 Toast 完成移除后执行。
    public static func remove(dismissHandler: DismissHandler? = nil) {
        MCToast.shared.clearAllToast(dismissHandler: dismissHandler)
    }
}

public extension MCToast {
    /// 显示一条纯文本 Toast。
    /// - Parameter value: 要显示的文本内容。
    /// - Returns: MCToastBuilder 对象，可继续链式配置样式、时长等。
    @discardableResult
    static func plainText(_ value: String) -> MCToastBuilder {
        MCToastBuilder.build(style: .text, text: value)
    }

    /// 显示一条带图标的 Toast，例如成功/失败/警告等。
    /// - Parameters:
    ///   - value: 要显示的文本内容。
    ///   - icon: 要显示的图标类型。
    /// - Returns: MCToastBuilder 对象，可继续链式配置样式、时长等。
    @discardableResult
    static func iconText(_ value: String, icon: IconType) -> MCToastBuilder {
        MCToastBuilder.build(style: .icon, text: value, icon: icon)
    }

    /// 显示一个“加载中” Toast，支持自定义提示文本。
    /// - Parameter value: 要显示的提示文本，默认是“加载中”。
    /// - Returns: MCToastBuilder 对象，可继续链式配置样式、时长等。
    @discardableResult
    static func loadingText(_ value: String = "加载中") -> MCToastBuilder {
        MCToastBuilder.build(style: .loading, text: value)
    }

    /// 显示一个自定义 View 的 Toast。
    /// - Parameter view: 需要展示的自定义视图。
    /// - Returns: MCToastBuilder 对象，可继续链式配置时长、响应策略等。
    @discardableResult
    static func custom(_ view: UIView) -> MCToastBuilder {
        MCToastBuilder.build(style: .custom, view: view)
    }
    
    /// 显示一个状态栏样式的 Toast（例如顶部横幅提示）。
    /// - Parameter view: 顶部展示的自定义 View。
    /// - Returns: MCToastBuilder 对象，可继续链式配置样式、时长等。
    @discardableResult
    static func statusBarView(_ view: UIView) -> MCToastBuilder {
        MCToastBuilder.build(style: .statusBar, view: view)
    }
}


extension MCToast {
    
    @discardableResult
    public static func showCustomView(_ customView: UIView,
                                      duration: CGFloat,
                                      respond: RespondPolicy,
                                      dismissHandler: DismissHandler? = nil) -> UIWindow? {
        shared.showCustomView(customView, duration: duration, respond: respond, dismissHandler: dismissHandler)
    }
    
    
    /// 成功类型的Toast
    /// - Parameters:
    ///   - text: 文字内容
    ///   - duration: 展示时间（秒）
    ///   - respond: 交互类型
    ///   - callback: 隐藏的回调
    @discardableResult
    public static func success(_ text:String,
                                  duration: CGFloat = MCToastConfig.shared.duration,
                                  respond: RespondPolicy = MCToastConfig.shared.respond,
                                  dismissHandler: DismissHandler? = nil) -> UIWindow? {
        
        return MCToast.showStatus(text: text, iconImage: IconType.success.getImage(), duration: duration, respond: respond, dismissHandler: dismissHandler)
    }
    
    
    /// 失败类型的Toast
    /// - Parameters:
    ///   - text: 文字内容
    ///   - duration: 展示时间（秒）
    ///   - respond: 交互类型
    ///   - callback: 隐藏的回调
    @discardableResult
    public static func failure(_ text: String,
                                  duration:CGFloat = MCToastConfig.shared.duration,
                                  respond: RespondPolicy = MCToastConfig.shared.respond,
                                  dismissHandler: DismissHandler? = nil) -> UIWindow?  {
        return MCToast.showStatus(text: text, iconImage: IconType.failure.getImage(), duration: duration, respond: respond, dismissHandler: dismissHandler)
    }
    
    
    /// 警告类型的Toast
    /// - Parameters:
    ///   - text: 文字内容
    ///   - duration: 展示时间（秒）
    ///   - respond: 交互类型
    ///   - callback: 隐藏的回调
    @discardableResult
    public static func warning(_ text: String,
                                  duration: CGFloat = MCToastConfig.shared.duration,
                                  respond: RespondPolicy = MCToastConfig.shared.respond,
                                  dismissHandler: DismissHandler? = nil) -> UIWindow? {
        return MCToast.showStatus(text: text, iconImage: IconType.warning.getImage(), duration: duration, respond: respond, dismissHandler: dismissHandler)
    }
    
    
    
    @discardableResult
    public static func showStatus(text: String,
                    iconImage: UIImage?,
                    duration: CGFloat,
                    respond: RespondPolicy,
                                  dismissHandler: DismissHandler? = nil) -> UIWindow? {
        shared.showStatus(text: text, iconImage: iconImage, duration: duration, respond: respond, dismissHandler: dismissHandler)
    }
    
    
    /// loading (菊花)
    ///
    /// - Parameters:
    ///   - text: 文字内容 默认为 "正在加载中"
    ///   - duration: 自动隐藏的时间
    ///   - font: 字体大小
    @discardableResult
    public static func loading(text: String = "正在加载中",
                                  duration: CGFloat = 0,
                                  respond: RespondPolicy = MCToastConfig.shared.respond,
                                  dismissHandler: DismissHandler? = nil) -> UIWindow? {
        
        if text.isEmpty {
            return MCToast.shared.loading(duration: duration, respond: respond, dismissHandler: dismissHandler)
        } else {
            return MCToast.shared.loading(text: text, duration: duration, respond: respond, dismissHandler: dismissHandler)
        }
    }
    
    
    /// 在状态栏栏显示一个toast
    /// - Parameters:
    ///   - text: 显示的文字内容
    ///   - duration: 显示的时长（秒）
    ///   - font: 文字字体
    ///   - backgroundColor: 背景颜色
    ///   - callback: 隐藏的回调
    @discardableResult
    public static func statusBar(
        view: UIView,
        duration: CGFloat = MCToastConfig.shared.duration,
        respond: MCToast.RespondPolicy = MCToastConfig.shared.respond,
        dismissHandler: DismissHandler? = nil
    ) -> UIWindow? {
        return MCToast.shared.noticeOnStatusBar(view: view, duration: duration, respond: respond, dismissHandler: dismissHandler)
    }
    
    
    
    /// 展示文字toast
    /// - Parameters:
    ///   - text: 文字内容
    ///   - offset: toast底部距离屏幕底部距离
    ///   - duration: 显示的时间（秒）
    ///   - respond: 交互类型
    ///   - callback: 隐藏的回调
    @discardableResult
    public static func text(_ text: String,
                               offset: CGFloat = MCToastConfig.shared.text.offset,
                               duration: CGFloat = MCToastConfig.shared.duration,
                               respond: RespondPolicy = MCToastConfig.shared.respond,
                               dismissHandler: DismissHandler? = nil) -> UIWindow? {
        return MCToast.shared.showText(text, position: .bottom(offset: offset), duration: duration, respond: respond, dismissHandler: dismissHandler)
        
    }
}

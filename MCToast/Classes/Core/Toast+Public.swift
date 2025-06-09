//
//  Toast+Public.swift
//  MCToast
//
//  Created by qixin on 2025/6/9.
//

import Foundation
extension MCToast {
    /// 开启键盘适配（注册键盘通知等）
    public static func enableKeyboardTracking() {
        KeyboardManager.shared.keyboardHeightChanged = { keyboardHeight, duration in
            shared.onKeyboardWillChangeFrame(height: keyboardHeight, duration: duration)
        }
    }

    /// 开启横竖屏适配（注册方向变化通知等）
    public static func enableOrientationTracking() {
        NotificationCenter.default.addObserver(shared, selector: #selector(onOrientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
}

extension MCToast {
    /// 移除toast
    /// - Parameter callback: 移除成功的回调
    public static func remove(dismissHandler: DismissHandler? = nil) {
        MCToast.shared.clearAllToast(dismissHandler: dismissHandler)
    }
}

public extension MCToast {
    static func plainText(_ value: String) -> MCToastBuilder {
        let builder = MCToastBuilder.build(style: .text, text: value)
        return builder
    }

    static func statusText(_ value: String, icon: IconType) -> MCToastBuilder {
        let builder = MCToastBuilder.build(style: .icon, text: value, icon: icon)
        return builder
    }

    static func loadingText(_ value: String = "加载中") -> MCToastBuilder {
        let builder = MCToastBuilder.build(style: .loading, text: value)
        return builder
    }

    static func custom(_ view: UIView) -> MCToastBuilder {
        let builder = MCToastBuilder.build(style: .custom, view: view)
        return builder
    }
    
    static func statusBar(_ view: UIView) -> MCToastBuilder {
        let builder = MCToastBuilder.build(style: .statusBar, view: view)
        return builder
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
        return MCToast.shared.showText(text, offset: offset, duration: duration, respond: respond, dismissHandler: dismissHandler)
        
    }
}

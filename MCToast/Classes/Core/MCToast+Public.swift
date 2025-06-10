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
    static func plainText(_ value: String, autoShow: Bool = true) -> MCToastBuilder {
        MCToastBuilder.build(style: .text, text: value, autoShow: autoShow)
    }

    /// 显示一条带图标的 Toast，例如成功/失败/警告等。
    /// - Parameters:
    ///   - value: 要显示的文本内容。
    ///   - icon: 要显示的图标类型。
    /// - Returns: MCToastBuilder 对象，可继续链式配置样式、时长等。
    @discardableResult
    static func iconText(_ value: String, icon: IconType, autoShow: Bool = true) -> MCToastBuilder {
        MCToastBuilder.build(style: .icon, text: value, icon: icon, autoShow: autoShow)
    }

    /// 显示一个“加载中” Toast，支持自定义提示文本。
    /// - Parameter value: 要显示的提示文本。
    /// - Returns: MCToastBuilder 对象，可继续链式配置样式、时长等。
    @discardableResult
    static func loadingText(_ value: String = "", autoShow: Bool = true) -> MCToastBuilder {
        MCToastBuilder.build(style: .loading, text: value, autoShow: autoShow)
    }

    /// 显示一个自定义 View 的 Toast。
    /// - Parameter view: 需要展示的自定义视图。
    /// - Returns: MCToastBuilder 对象，可继续链式配置时长、响应策略等。
    @discardableResult
    static func custom(_ view: UIView, autoShow: Bool = true) -> MCToastBuilder {
        MCToastBuilder.build(style: .custom, view: view, autoShow: autoShow)
    }
    
    /// 显示一个状态栏样式的 Toast（例如顶部横幅提示）。
    /// - Parameter view: 顶部展示的自定义 View。
    /// - Returns: MCToastBuilder 对象，可继续链式配置样式、时长等。
    @discardableResult
    static func statusBarView(_ view: UIView, autoShow: Bool = true) -> MCToastBuilder {
        MCToastBuilder.build(style: .statusBar, view: view, autoShow: autoShow)
    }
}

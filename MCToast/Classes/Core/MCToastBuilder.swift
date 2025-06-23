//
//  ToastBuilder.swift
//  MCToast
//
//  Created by qixin on 2025/6/9.
//

import Foundation
import UIKit



extension MCToastBuilder {
    // MARK: - 链式方法

    /// 设置 Toast 显示的时长，单位为秒。
    /// - Parameter value: 显示时长，默认为 MCToastConfig 中的默认值。
    /// - Returns: 返回当前 MCToastBuilder 实例，支持链式调用。
    @discardableResult
    public func duration(_ value: CGFloat) -> Self {
        self.duration = value
        return self
    }
    
    /// 设置 Toast 的显示位置
    /// - Parameter value: 显示位置（如居中或距离底部一定偏移）
    ///
    /// 使用 `.top(offset)` 表示距离屏幕顶部部向下偏移 `offset` 显示
    /// 使用 `.center` 表示垂直居中显示
    /// 使用 `.bottom(offset)` 表示距离屏幕底部向上偏移 `offset` 显示
    ///
    /// 默认值为 `.center`
    @discardableResult
    public func position(_ value: MCToast.Position) -> Self {
        self.position = value
        return self
    }


    /// 设置 Toast 的响应策略，控制用户交互时是否允许点击穿透等。
    /// - Parameter policy: 响应策略，见 MCToast.RespondPolicy 枚举定义。
    /// - Returns: 返回当前 MCToastBuilder 实例，支持链式调用。
    @discardableResult
    public func respond(_ policy: MCToast.RespondPolicy) -> Self {
        self.respond = policy
        return self
    }

    /// 设置 Toast 显示时的回调，显示时会触发该闭包。
    /// - Parameter handler: 显示时调用的闭包，无参数无返回值。
    /// - Returns: 返回当前 MCToastBuilder 实例，支持链式调用。
    @discardableResult
    public func showHandler(_ handler: @escaping () -> Void) -> Self {
        self.onShowHandler = handler
        return self
    }

    /// 设置 Toast 被移除时的回调，移除完成后会触发该闭包。
    /// - Parameter handler: 移除时调用的闭包，参数为移除原因，具体见 MCToast.DismissHandler 类型定义。
    /// - Returns: 返回当前 MCToastBuilder 实例，支持链式调用。
    @discardableResult
    public func dismissHandler(_ handler: @escaping MCToast.DismissHandler) -> Self {
        self.dismissHandler = handler
        return self
    }
    
    public func show() {
        showToast()
    }
}




public final class MCToastBuilder {
    fileprivate var style: MCToast.Style?
    fileprivate var text: String?
    /// 内容视图距离屏幕底部的偏移量（默认居中）
    /// - 若设置为大于 0 的值，toast 将从屏幕底部向上偏移对应距离显示
    /// - 若未设置（或为 0），toast 将默认垂直居中显示
    fileprivate var position: MCToast.Position?
    fileprivate var iconType: MCToast.IconType?
    fileprivate var customView: UIView?

    var duration: CGFloat?
    var respond: MCToast.RespondPolicy = MCToastConfig.shared.respond
    var onShowHandler: MCToast.ShowHandler?
    var dismissHandler: MCToast.DismissHandler?

    public var window: MCToastWindow?

    // MARK: - 初始化入口（内部调用）
    static func build(style: MCToast.Style, text: String? = nil, icon: MCToast.IconType? = nil, view: UIView? = nil, autoShow: Bool) -> MCToastBuilder {
        let builder = MCToastBuilder()
        builder.style = style
        builder.text = text
        builder.iconType = icon
        builder.customView = view

        if autoShow {
            builder.tryScheduleShowIfNeeded()
        }
        
        return builder
    }
}



extension MCToastBuilder {
    // MCToastBuilder 是一个 class（引用类型），链式调用设置的值，其实是在 修改同一个实例的属性，
    // tryScheduleShowIfNeeded() 里的 DispatchQueue.main.async { self.show() } 是异步执行的，
    // 因此在它真正执行 .show() 时，链式设置早已完成。
    private func tryScheduleShowIfNeeded() {
        DispatchQueue.main.async {
            self.showToast()
        }
    }


    fileprivate func showToast() {
        let window: MCToastWindow?
        guard let style = style else { return }
        switch style {
        case .text:
            let duration = duration ?? MCToastConfig.shared.duration
            
            let position = position ?? .bottom(offset: MCToastConfig.shared.text.offset)
            window = MCToast.shared.showText(
                text ?? "",
                position: position,
                duration: duration,
                respond: respond,
                dismissHandler: dismissHandler
            )
        case .icon:
            guard let icon = iconType else { return }
            let duration = duration ?? MCToastConfig.shared.duration
            window = MCToast.shared.showStatus(
                text: text ?? "",
                iconImage: icon.getImage(),
                duration: duration,
                respond: respond,
                dismissHandler: dismissHandler
            )
        case .loading:
            
            let duration = duration ?? 0
            window = MCToast.shared.loading(
                text: text ?? "",
                duration: duration,
                respond: respond,
                dismissHandler: dismissHandler
            )
        case .custom:
            guard let view = customView else { return }
            let duration = duration ?? MCToastConfig.shared.duration
            window = MCToast.shared.showCustomView(
                view,
                duration: duration,
                respond: respond,
                dismissHandler: dismissHandler
            )
        case .statusBar:
            guard let view = customView else { return }
            let duration = duration ?? MCToastConfig.shared.duration
            window = MCToast.shared.noticeOnStatusBar(view: view, duration: duration, respond: respond, dismissHandler: dismissHandler)
        }
        self.window = window
        onShowHandler?()
    }
}

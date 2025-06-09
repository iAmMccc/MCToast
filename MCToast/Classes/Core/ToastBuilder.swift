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
    @discardableResult
    public func duration(_ value: CGFloat) -> Self {
        self.duration = value
        return self
    }

    @discardableResult
    public func respond(_ policy: MCToast.RespondPolicy) -> Self {
        self.respond = policy
        return self
    }

    @discardableResult
    public func onShow(_ handler: @escaping () -> Void) -> Self {
        self.onShowHandler = handler
        return self
    }

    @discardableResult
    public func dismissHandler(_ handler: @escaping MCToast.DismissHandler) -> Self {
        self.dismissHandler = handler
        return self
    }
}



public final class MCToastBuilder {
    fileprivate var style: MCToast.Style?
    fileprivate var text: String?
    fileprivate var iconType: MCToast.IconType?
    fileprivate var customView: UIView?

    var duration: CGFloat = MCToastConfig.shared.duration
    var respond: MCToast.RespondPolicy = MCToastConfig.shared.respond
    var onShowHandler: (() -> Void)?
    var dismissHandler: MCToast.DismissHandler?


    // MARK: - 初始化入口（内部调用）
    static func build(style: MCToast.Style, text: String? = nil, icon: MCToast.IconType? = nil, view: UIView? = nil) -> MCToastBuilder {
        let builder = MCToastBuilder()
        builder.style = style
        builder.text = text
        builder.iconType = icon
        builder.customView = view

        builder.tryScheduleShowIfNeeded()
        return builder
    }
}



extension MCToastBuilder {
    // MCToastBuilder 是一个 class（引用类型），链式调用设置的值，其实是在 修改同一个实例的属性，
    // tryScheduleShowIfNeeded() 里的 DispatchQueue.main.async { self.show() } 是异步执行的，
    // 因此在它真正执行 .show() 时，链式设置早已完成。
    private func tryScheduleShowIfNeeded() {
        DispatchQueue.main.async {
            self.show()
        }
    }


    fileprivate func show() {
        onShowHandler?()

        switch style {
        case .text:
            MCToast.shared.showText(
                text ?? "",
                duration: duration,
                respond: respond,
                dismissHandler: dismissHandler
            )
        case .icon:
            guard let icon = iconType else { return }
            MCToast.shared.showStatus(
                text: text ?? "",
                iconImage: icon.getImage(),
                duration: duration,
                respond: respond,
                dismissHandler: dismissHandler
            )
        case .loading:
            MCToast.shared.loading(
                text: text ?? "",
                duration: duration,
                respond: respond,
                dismissHandler: dismissHandler
            )
        case .custom:
            guard let view = customView else { return }
            MCToast.shared.showCustomView(
                view,
                duration: duration,
                respond: respond,
                dismissHandler: dismissHandler
            )
        case .statusBar:
            guard let view = customView else { return }
            MCToast.shared.noticeOnStatusBar(view: view, duration: duration, respond: respond, dismissHandler: dismissHandler)
        case .none:
            break
        }
    }
}

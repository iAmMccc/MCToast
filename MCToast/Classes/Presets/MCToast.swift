//
//  MCToast.swift
//  MCToast
//
//  Created by Mccc on 2019/4/19.
//


/** 适配横竖屏
 * 【done】【Bug】为啥在viewdidload中加载，会自动隐藏？
 * 【done】将所有的frame修改为layout布局。
 * 【done】demo中写横竖屏切换的方法，验证效果。
 * 【done】应该要把MCToast 设计成一个单例。
 * 【done】处理键盘事件
 * 【done】支持横竖屏的切换，自动适配横竖屏的配置参数。
 * 支持x号按钮，仅仅在长时间显示的时候。做一个配置吧
 * 【不支持】支持页面返回移除。
 * 支持显示倒计时。
 * 支持json动画。
 * 是否要移除windows，只需要一个window，window中持有contentView，contentView中持有底部约束。这样就好处理横竖屏切换，好处理键盘事件
 * 尝试优化，横竖屏切换+键盘弹出的时候，的效果。 不好处理。
 * 使用链式表达式，onshow，dimissHander等，
 */



/**
 loading 里面新增
 
 1. 帧动画
 2. json动画
 3. 系统loading
 4. 是否需要文字提示
 5. 如何动态更新文字 （比如上传图片的数量的改动）
 6.
 */


import Foundation
import UIKit

public class MCToast: NSObject {
    
    internal static let shared = MCToast()
    
    /// 管理所有的windows
    internal var toastWindow: MCToastWindow?
    
    internal static var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first(where: { $0.isKeyWindow })
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    
    private override init() { }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}


extension MCToast {
    
    func createWindow(
        respond: RespondPolicy,
        style: Style,
        position: Position,
        size: CGSize? = nil
    ) -> MCToastWindow {
        
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }) else {
            fatalError("无法获取当前活跃 Scene")
        }
        
        // 创建承载视图
        let contentView = createcontentView(style: style, position: position)
        
        // 创建window
        let window = MCToastWindow(windowScene: windowScene, contentView: contentView, response: respond)
        self.toastWindow = window
        
        // 设置承载视图的约束
        setupContentViewConstraints(contentView, style: style, size: size)
        
        return window
    }
    
    
    /// 创建主视图区域
    func createcontentView(style: Style, position: Position) -> MCToastContentView {
        let contentView = MCToastContentView()
        contentView.position = position
        switch style {
        case .custom, .statusBar:
            contentView.backgroundColor = .clear
        default:
            contentView.backgroundColor = MCToastConfig.shared.background.resolvedColor
            contentView.alpha = 0.0
            contentView.layer.cornerRadius = MCToastConfig.shared.icon.cornerRadius
            contentView.layer.masksToBounds = true
        }
        
        
        UIView.animate(withDuration: 0.2) {
            contentView.alpha = 1
        }
        return contentView
    }
    
    func setupContentViewConstraints(
        _ contentView: MCToastContentView,
        style: MCToast.Style,
        size: CGSize? = nil
    ) {
        guard let superview = self.toastWindow else {
            fatalError("need superview")
        }

        // 通用居中X
        contentView.centerXAnchor.constraint(equalTo: superview.centerXAnchor).isActive = true

        switch style {
        case .text:
            // 限制最大宽度
            let maxWidth = MCToastConfig.shared.text.maxWidth + MCToastConfig.shared.text.padding.horizontal
            contentView.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth).isActive = true

            switch contentView.position {
            case .center:
                contentView.centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true

            case .bottom(let offset):
                let keyboardHeight = KeyboardManager.shared.currentVisibleKeyboardHeight
                let bottomOffset = keyboardHeight > 0 ? keyboardHeight + MCToastConfig.shared.text.avoidKeyboardOffsetY : offset

                let tempY = -abs(bottomOffset)
                
                let bottomConstraint = contentView.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: tempY)
                bottomConstraint.isActive = true
                contentView.bottomConstraint = bottomConstraint
            case .top(offset: let offset):
                contentView.topAnchor.constraint(equalTo: superview.topAnchor, constant: offset).isActive = true
            }

        case .icon, .loading:
            // 固定宽度，居中显示
            contentView.centerYAnchor.constraint(equalTo: superview.centerYAnchor).isActive = true
            contentView.widthAnchor.constraint(equalToConstant: MCToastConfig.shared.icon.toastWidth).isActive = true

        case .custom:
            guard let size = size else { return }
            NSLayoutConstraint.activate([
                contentView.widthAnchor.constraint(equalToConstant: size.width),
                contentView.heightAnchor.constraint(equalToConstant: size.height),
                contentView.centerYAnchor.constraint(equalTo: superview.centerYAnchor)
            ])

        case .statusBar:
            guard let size = size else { return }
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: superview.topAnchor),
                contentView.heightAnchor.constraint(equalToConstant: size.height),
                contentView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: superview.trailingAnchor)
            ])
        }
    }

}

extension MCToast {
    @objc func onOrientationChanged() {
        // 重新读取offset计算属性，更新约束
        UIView.animate(withDuration: 0.3) {
            // 让window重新布局
            self.toastWindow?.contentView.bottomConstraint?.constant = -MCToastConfig.shared.text.offset
            self.toastWindow?.layoutIfNeeded()
        }
    }
    
    @objc func onKeyboardWillChangeFrame(height: CGFloat, duration: CGFloat) {
        guard let window = toastWindow,
              let constraint = self.toastWindow?.contentView.bottomConstraint else {
            return
        }
        
        let targetOffset = max(height+MCToastConfig.shared.text.avoidKeyboardOffsetY, MCToastConfig.shared.text.offset)
        constraint.constant = -targetOffset
        let curve = UIView.AnimationCurve.easeInOut.rawValue
        
        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: UIView.AnimationOptions(rawValue: UInt(curve << 16)),
                       animations: {
            window.layoutIfNeeded()
        },
                       completion: nil)
    }
    
}


extension MCToast {
    
    /// Toast 显示时的回调闭包类型
    public typealias ShowHandler = () -> Void
    
    /// Toast 消失时的回调闭包类型
    public typealias DismissHandler = () -> Void
    
    /// Toast 事件响应策略，控制 Toast 显示期间用户交互行为
    public enum RespondPolicy {
        /// Toast 显示期间禁止所有事件交互，阻止用户操作
        case forbid
        /// Toast 显示期间允许所有事件交互，不阻止用户操作
        case allow
        /// Toast 显示期间只允许导航栏区域的事件交互，其他区域阻止
        case allowNav
    }
    
    /// Toast 展示样式类型，决定显示的内容和样式
    public enum Style {
        /// 纯文本类型 Toast
        case text
        /// 带有图标的 Toast 类型
        case icon
        /// 加载中动画类型 Toast
        case loading
        /// 自定义视图类型 Toast
        case custom
        /// 状态栏样式 Toast（通常显示在状态栏区域）
        case statusBar
    }
    
    /// 图标类型枚举，用于 icon 类型的 Toast
    public enum IconType {
        /// 成功图标
        case success
        /// 失败图标
        case failure
        /// 警告图标
        case warning
        /// 自定义图标
        case custom(UIImage?)
    }
    
    /// Toast 的展示位置枚举
    public enum Position {
        
        case top(offset: CGFloat)
        
        /// Toast 居中显示（默认值）
        case center

        /// Toast 显示在距屏幕底部一定距离的位置
        /// - Parameter offset: 距离屏幕底部的偏移量（单位：pt）
        ///   - 例如 offset = 60 表示距离屏幕底部 60pt 显示
        case bottom(offset: CGFloat)
    }
}

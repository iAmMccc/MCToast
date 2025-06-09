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
 * 支持x号按钮
 * 【不支持】支持页面返回移除。
 * 支持显示倒计时。
 * 支持json动画。
 * 是否要移除windows，只需要一个window，window中持有contentView，contentView中持有底部约束。这样就好处理横竖屏切换，好处理键盘事件
 * 尝试优化，横竖屏切换+键盘弹出的时候，的效果。 不好处理。
 * 使用链式表达式，onshow，dimissHander等，
 */



import Foundation
import UIKit

internal let sn_topBar: Int = 1001



public class MCToast: NSObject {
    
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
    
    
    internal static let shared = MCToast()

    /// 管理所有的windows
    internal var toastWindow: ToastWindow?
    
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
    
    func createWindow(respond: RespondPolicy, style: Style, offset: CGFloat? = nil, size: CGSize? = nil) -> ToastWindow {
        
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }) else {
            fatalError("无法获取当前活跃 Scene")
        }
        
        // 创建承载视图
        let contentView = createcontentView()
        
        // 创建window
        let window = ToastWindow(windowScene: windowScene, contentView: contentView, response: respond)
        self.toastWindow = window
        
        // 设置承载视图的约束
        setupContentViewConstraints(contentView, style: style, offset: offset, size: size)
        
        return window
    }

    
    /// 创建主视图区域
    func createcontentView() -> ToastContentView {
        let contentView = ToastContentView()
        contentView.layer.cornerRadius = MCToastConfig.shared.icon.cornerRadius
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = MCToastConfig.shared.background.resolvedColor
        contentView.alpha = 0.0

        UIView.animate(withDuration: 0.2) {
            contentView.alpha = 1
        }
        return contentView
    }
    
    func setupContentViewConstraints(_ contentView: ToastContentView, style: MCToast.Style, offset: CGFloat? = nil, size: CGSize? = nil) {
        
        guard let superview = self.toastWindow else { fatalError("need superview") }
        
        
        switch style {
        case .text:
            // 先给个宽最大限制，防止太宽
            let maxWidth = MCToastConfig.shared.text.maxWidth + MCToastConfig.shared.text.padding.horizontal
            NSLayoutConstraint.activate([
                contentView.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
                // 限制最大宽度
                contentView.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth)
            ])

            var bottomConstraint: NSLayoutConstraint
            if KeyboardManager.shared.currentVisibleKeyboardHeight > 0 {
                let bottomOffset = -KeyboardManager.shared.currentVisibleKeyboardHeight - MCToastConfig.shared.text.avoidKeyboardOffsetY
                bottomConstraint = contentView.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottomOffset)
            } else {
                
                let bottomOffset: CGFloat = -(offset ?? MCToastConfig.shared.text.offset)
                bottomConstraint = contentView.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottomOffset)
            }
            bottomConstraint.isActive = true
            contentView.bottomConstraint = bottomConstraint
            break
        case .icon:
            NSLayoutConstraint.activate([
                contentView.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
                contentView.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
                contentView.widthAnchor.constraint(equalToConstant: MCToastConfig.shared.icon.toastWidth)
            ])
        case .loading:
            NSLayoutConstraint.activate([
                contentView.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
                contentView.centerYAnchor.constraint(equalTo: superview.centerYAnchor),
                contentView.widthAnchor.constraint(equalToConstant: MCToastConfig.shared.icon.toastWidth)
            ])

        case .custom:
            guard let size = size else { return }
            NSLayoutConstraint.activate([
                contentView.widthAnchor.constraint(equalToConstant: size.width),
                contentView.heightAnchor.constraint(equalToConstant: size.height),
                contentView.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
                contentView.centerYAnchor.constraint(equalTo: superview.centerYAnchor)
            ])
        case .statusBar:
            guard let size = size else { return }
  
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: superview.topAnchor),
                contentView.heightAnchor.constraint(equalToConstant: size.height),
                contentView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            ])
//            NSLayoutConstraint.activate([
//                // containerView 约束
//                contentView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
//                contentView.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
//                contentView.topAnchor.constraint(equalTo: superview.topAnchor),
//                contentView.heightAnchor.constraint(equalToConstant: size.height)
//            ])
        }
    }
}

extension MCToast {
    @objc private func onOrientationChanged() {
        // 重新读取offset计算属性，更新约束
        UIView.animate(withDuration: 0.3) {
            // 让window重新布局
            self.toastWindow?.contentView.bottomConstraint?.constant = -MCToastConfig.shared.text.offset
            self.toastWindow?.layoutIfNeeded()
        }
    }
    
    @objc private func onKeyboardWillChangeFrame(height: CGFloat, duration: CGFloat) {
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
    // toast消失的回调
    public typealias DismissHandler = () -> Void
    
    public enum RespondPolicy {
        /// Toast展示期间不允许事件交互
        case forbid
        /// Toast展示期间允许事件交互
        case allow
        /// Toast展示期间只允许导航条交互
        case allowNav
    }
    
    
    public enum Style {
        /// 文本类型
        case text
        /// icon类型
        case icon
        /// loading类型
        case loading
        /// 自定义类型
        case custom
        /// 状态栏
        case statusBar
    }
}

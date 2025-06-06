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
 * 应该要把MCToast 设计成一个单例。
 * 处理键盘事件
 * 【done】支持横竖屏的切换，自动适配横竖屏的配置参数。
 * 支持x号按钮
 * 【不支持】支持页面返回移除。
 * 支持显示倒计时。
 * 支持json动画。
 * 是否要移除windows，只需要一个window，window中持有mainView，mainView中持有底部约束。这样就好处理横竖屏切换，好处理键盘事件。
 */



import Foundation
import UIKit

internal let sn_topBar: Int = 1001



public class MCToast: NSObject {
    private static var isInitialized = false

    static let shared = MCToast()
    
    // 记录底部约束，横竖屏切换时更新
    var mainViewBottomConstraint: NSLayoutConstraint?

    /// 管理所有的windows
    static var windows: [UIWindow] = []
    
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
    
    public static func initToast() {
        guard !isInitialized else { return }
        isInitialized = true
        NotificationCenter.default.addObserver(shared, selector: #selector(onOrientationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
        BTKeyboardManager.shared.keyboardHeightChanged = { keyboardHeight, duration in
            shared.onKeyboardWillChangeFrame(height: keyboardHeight, duration: duration)
        }
    }
}


extension MCToast {
    public typealias MCToastCallback = () -> Void
    
    public enum MCToastRespond {
        /// Toast展示期间不允许事件交互
        case forbid
        /// Toast展示期间允许事件交互
        case allow
        /// Toast展示期间只允许导航条交互
        case allowNav
    }
    
    
    public enum ToastType {
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


extension MCToast {
    
    
    static func createWindow(respond: MCToastRespond) -> UIWindow {
        let window: ToastWindow


        
        if #available(iOS 13.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }) else {
                fatalError("无法获取当前活跃 Scene")
            }

            window = ToastWindow(windowScene: windowScene)
        } else {
            window = ToastWindow()
        }
        window.response = respond
        

        window.backgroundColor = .clear
        
        // 如果不设置，将无法使用现代 UIKit 的很多功能（比如自动旋转支持、键盘避让、响应链传递等）
        window.rootViewController = UIViewController()
        window.rootViewController?.view.backgroundColor = .clear
        window.windowLevel = .statusBar + 1
        window.isHidden = false

        return window
    }

    
    /// 创建主视图区域
    static func createMainView(bgColor: UIColor? = nil) -> UIView {
        let mainView = UIView()
        mainView.layer.cornerRadius = MCToastConfig.shared.icon.cornerRadius
        mainView.layer.masksToBounds = true
        mainView.backgroundColor = bgColor ?? MCToastConfig.shared.background.color.withAlphaComponent(MCToastConfig.shared.background.colorAlpha)
        mainView.alpha = 0.0
        mainView.translatesAutoresizingMaskIntoConstraints = false

        UIView.animate(withDuration: 0.2) {
            mainView.alpha = 1
        }

        return mainView
    }
    
    @objc private func onOrientationChanged() {
        // 重新读取offset计算属性，更新约束
        UIView.animate(withDuration: 0.3) {
            // 让window重新布局
            self.mainViewBottomConstraint?.constant = -MCToastConfig.shared.text.offset
            MCToast.windows.first?.layoutIfNeeded()

        }
    }
    
    @objc private func onKeyboardWillChangeFrame(height: CGFloat, duration: CGFloat) {
        guard let window = MCToast.windows.first,
              let constraint = mainViewBottomConstraint else {
            return
        }


        let targetOffset = max(height, MCToastConfig.shared.text.offset)

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

//
//  MCToast.swift
//  MCToast
//
//  Created by Mccc on 2019/4/19.
//


/** 适配横竖屏
 * 【Bug】为啥在viewdidload中加载，会自动隐藏？
 * 将所有的frame修改为layout布局。
 * demo中写横竖屏切换的方法，验证效果。
 * 支持横竖屏的切换，自动适配横竖屏的配置参数。
 * 支持x号按钮
 * 支持页面返回移除。
 * 支持显示倒计时。
 * 支持json动画。
 * loading的颜色支持配置。
 * 处理键盘事件
 */



import Foundation
import UIKit

internal let sn_topBar: Int = 1001



public class MCToast: NSObject {
    
    /// 管理所有的windows
    internal static var windows = Array<UIWindow?>()
    
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
}


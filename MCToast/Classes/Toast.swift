//
//  MCToast.swift
//  MCToast
//
//  Created by Mccc on 2019/4/19.
//


/** 适配横竖屏
 * 将所有的frame修改为layout布局。
 * demo中写横竖屏切换的方法，验证效果。
 */



import Foundation
import UIKit

internal let sn_topBar: Int = 1001

var kScreenWidth: CGFloat {
    UIScreen.main.bounds.size.width
}
var kScreenHeight: CGFloat {
    UIScreen.main.bounds.size.height
}



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
    }
}


extension MCToast {
    
    
    /// 创建Window
    /// - Parameters:
    ///   - respond: 交互类型
    ///   - frame: window的frame
    static func createWindow(respond: MCToastRespond, isLandscape: Bool = false, size: CGSize, toastType: ToastType, offset: CGFloat? = nil) -> UIWindow {
        
        let window: UIWindow

        if #available(iOS 13.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }) else {
                fatalError("无法获取当前活跃 Scene")
            }
            
            window = UIWindow(windowScene: windowScene)
        } else {
            window = UIWindow()
        }
        
        window.backgroundColor = UIColor.clear
        window.frame.size = size

        guard let keyWindow = keyWindow else { return window }
                
        switch respond {
        case .allow:
            window.frame.size = size
            
            
            let centerX = keyWindow.frame.maxX / 2
            let centerY = keyWindow.frame.maxY / 2
            
            switch toastType {
            case .text:
                var tempOffset: CGFloat = MCToastConfig.shared.text.offset
                if let offset = offset {
                    tempOffset = offset
                }
                let y = kScreenHeight - tempOffset - size.height / 2
                window.center = CGPoint(x: centerX, y: y)
            default:
                window.center = CGPoint(x: centerX, y: centerY)
            }
        case .forbid:
            // 完全全屏UI展示会异常。具体问题待排查。
            if isLandscape {
                window.frame = CGRect.init(x: 0, y: 0, width: max(kScreenHeight, kScreenWidth), height: min(kScreenHeight, kScreenWidth))
            } else {
                window.frame.size = CGSize(width: keyWindow.frame.width - 6, height: keyWindow.frame.height)
                window.center = keyWindow.center
            }
            
        case .allowNav:
            guard let vc = UIViewController.current() else {
                return window
            }

            let rectNav = vc.navigationController?.navigationBar.frame
            let maxY = rectNav?.maxY ?? 0
            window.frame = CGRect.init(x: 0, y: maxY, width: kScreenWidth, height: kScreenHeight - maxY)
        }
        
        
        window.windowLevel = UIWindow.Level.init(9999999)
        window.isHidden = false
        
        return window
    }
    
    /// 创建主视图区域
    static func createMainView(bgColor: UIColor? = nil) -> UIView {

        
        let mainView = UIView()
        mainView.layer.cornerRadius = MCToastConfig.shared.icon.cornerRadius
        mainView.layer.masksToBounds = true
        
        if let bg = bgColor {
            mainView.backgroundColor = bg
        } else {
            mainView.backgroundColor = MCToastConfig.shared.background.color.withAlphaComponent(MCToastConfig.shared.background.colorAlpha)
        }
        
        

        mainView.alpha = 0.0
        UIView.animate(withDuration: 0.2, animations: {
            mainView.alpha = 1
        })
                
        return mainView
    }
}



//
//  MCToastWindow.swift
//  MCToast
//
//  Created by qixin on 2025/6/5.
//

import Foundation


public class MCToastWindow: UIWindow {
    
    public var contentView: MCToastContentView
    
    var response: MCToast.RespondPolicy


    // 自定义构造器，增加 contentView 参数
    init(windowScene: UIWindowScene, contentView: MCToastContentView, response: MCToast.RespondPolicy) {
        self.response = response
        self.contentView = contentView
        
        super.init(windowScene: windowScene)
        
        addSubview(contentView)
        
        isHidden = false
        windowLevel = .statusBar + 1
        backgroundColor = .clear
        
        // 如果不设置，将无法使用现代 UIKit 的很多功能（比如自动旋转支持、键盘避让、响应链传递等）
        rootViewController = MCToastRootViewController()
        rootViewController?.view.backgroundColor = .clear
    }


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // 判断是否可以响应点击
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
       
        let topInset = safeAreaInsets.top
        let navBarFrame = CGRect(x: 0, y: 0, width: bounds.width, height: topInset + 44)
        
        switch response {
        case .forbid:
            return true
        case .allow:
            return false
        case .allowNav:
            if navBarFrame.contains(point) {
                return false
            }
            return true
        }
    }
}


/// 用来处理状态栏颜色
final class MCToastRootViewController: UIViewController {
    
    private var topViewController: UIViewController? {
        return UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow && $0 !== self.view.window })?
            .rootViewController
            .flatMap { UIApplication.shared.topMostViewController(base: $0) }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        topViewController?.preferredStatusBarStyle ?? .default
    }

    override var prefersStatusBarHidden: Bool {
        topViewController?.prefersStatusBarHidden ?? false
    }
}

extension UIApplication {
    /// 获取当前正在展示的最顶层 ViewController
    func topMostViewController(base: UIViewController? = UIApplication.shared._mainKeyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topMostViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            return topMostViewController(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return topMostViewController(base: presented)
        }
        return base
    }

    /// 获取主 App 的 keyWindow（排除 toast 自己的 window）
    fileprivate var _mainKeyWindow: UIWindow? {
        return self.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first(where: { $0.isKeyWindow })
    }
}


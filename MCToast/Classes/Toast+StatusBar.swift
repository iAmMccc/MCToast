//
//  MCToast+noticeBar.swift
//  MCToast
//
//  Created by Mccc on 2020/6/24.
//

import Foundation

extension UIResponder {
    
    /// 在状态栏栏显示一个toast
    /// - Parameters:
    ///   - text: 显示的文字内容
    ///   - duration: 显示的时长（秒）
    ///   - font: 文字字体
    ///   - backgroundColor: 背景颜色
    ///   - callback: 隐藏的回调
    @discardableResult
    public func statusBar(
        view: UIView,
        duration: CGFloat = MCToastConfig.shared.duration,
        dismissHandler: MCToast.DismissHandler? = nil
    ) -> UIWindow? {
        return MCToast.shared.noticeOnStatusBar(view: view, duration: duration, dismissHandler: dismissHandler)
    }
}


extension MCToast {
    
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
        dismissHandler: DismissHandler? = nil
    ) -> UIWindow? {
        return MCToast.shared.noticeOnStatusBar(view: view, duration: duration, dismissHandler: dismissHandler)
    }
}



// MARK: - 在状态栏上显示提示框
extension MCToast {
    
    @discardableResult
    internal func noticeOnStatusBar(
        view: UIView,
        duration: CGFloat,
        dismissHandler: DismissHandler? = nil
    ) -> UIWindow? {
        
        let contentHeight = view.frame.size.height
        if contentHeight <= 0 {
            return nil
        }
        func getWindow() -> UIWindow {
            clearAllToast()
            
            let window = createWindow(respond: .allow, style: .statusBar, size: CGSize(width: 0, height: contentHeight))
            window.contentView.backgroundColor = view.backgroundColor
            window.contentView.addSubview(view)
            window.contentView.tag = sn_topBar
            // 动画滑入
            UIView.animate(withDuration: 0.3, animations: {
                window.frame.origin.y = 0
            }, completion: { _ in
                self.autoRemove(window: window, duration: duration, dismissHandler: dismissHandler)
            })
            
            return window
        }
        
        var result: UIWindow?
        DispatchQueue.main.safeSync {
            result = getWindow()
        }
        return result
    }
}

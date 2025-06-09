//
//  MCToast+noticeBar.swift
//  MCToast
//
//  Created by Mccc on 2020/6/24.
//

import Foundation


internal let sn_topBar: Int = 1001

// MARK: - 在状态栏上显示提示框
extension MCToast {
    
    @discardableResult
    internal func noticeOnStatusBar(
        view: UIView,
        duration: CGFloat,
        respond: MCToast.RespondPolicy,
        dismissHandler: DismissHandler? = nil
    ) -> UIWindow? {
        
        let contentHeight = view.frame.size.height
        if contentHeight <= 0 {
            return nil
        }
        func getWindow() -> UIWindow {
            clearAllToast()
            
            let window = createWindow(respond: respond, style: .statusBar, size: CGSize(width: 0, height: contentHeight))
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

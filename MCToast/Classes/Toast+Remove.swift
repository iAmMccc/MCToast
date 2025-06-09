//
//  MCToast+Remove.swift
//  MCToast
//
//  Created by Mccc on 2020/6/24.
//

import Foundation


extension UIResponder {
    
    /// 移除toast
    /// - Parameter callback: 移除成功的回调
    public func remove(dismissHandler: MCToast.DismissHandler? = nil) {
        MCToast.shared.clearAllToast(dismissHandler: dismissHandler)
    }
}

extension MCToast {
    /// 移除toast
    /// - Parameter callback: 移除成功的回调
    public static func remove(dismissHandler: DismissHandler? = nil) {
        MCToast.shared.clearAllToast(dismissHandler: dismissHandler)
    }
}


extension MCToast {
    
    /// 隐藏窗口
    private func hideWindow(_ window: UIWindow) {
        guard let toastView = window.subviews.first else { return }
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        UIView.animate(withDuration: 0.2, animations: {
            if toastView.tag == sn_topBar {
                toastView.frame.origin.y = -toastView.frame.height
            }
            toastView.alpha = 0
        }, completion: { _ in
            toastView.removeFromSuperview()
            window.isHidden = true
            self.toastWindow = nil
        })
    }

    /// 手动隐藏通知
    @objc func hideNotice(_ sender: AnyObject) {
        if let window = sender as? UIWindow {
            hideWindow(window)
        }
    }
    
    /// 清空所有 Toast
    func clearAllToast(dismissHandler: DismissHandler? = nil) {
        DispatchQueue.main.safeSync {
            self.toastWindow?.subviews.forEach { $0.removeFromSuperview() }
            self.toastWindow?.isHidden = true
            self.toastWindow = nil
        }
        dismissHandler?()
    }

    /// 自动移除 toast
    func autoRemove(window: UIWindow, duration: CGFloat, dismissHandler: DismissHandler?) {
        guard duration > 0 else { return }

        let task = DispatchWorkItem {
            self.hideWindow(window)
            dismissHandler?()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: task)
    }
}

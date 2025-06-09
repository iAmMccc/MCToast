//
//  MCToast+Remove.swift
//  MCToast
//
//  Created by Mccc on 2020/6/24.
//

import Foundation



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

    /// 自动管理 Toast 生命周期（显示、隐藏和回调）
    func manageLifecycle(
        window: UIWindow,
        duration: CGFloat,
        showHandler: ShowHandler?,
        dismissHandler: DismissHandler?
    ) {
        // 先调用显示回调
        showHandler?()

        // 如果 duration <= 0，代表不自动隐藏，直接返回
        guard duration > 0 else { return }

        let task = DispatchWorkItem {
            self.hideWindow(window)
            dismissHandler?()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: task)
    }
}

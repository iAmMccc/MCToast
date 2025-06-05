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
    public func mc_remove(callback: MCToast.MCToastCallback? = nil) {
        MCToast.clearAllToast(callback: callback)
    }
}

extension MCToast {
    /// 移除toast
    /// - Parameter callback: 移除成功的回调
    public static func mc_remove(callback: MCToast.MCToastCallback? = nil) {
        MCToast.clearAllToast(callback: callback)
    }
}

private var hideTasks: [UIWindow: DispatchWorkItem] = [:]

extension MCToast {
    
    /// 隐藏窗口
    private static func hideWindow(_ window: UIWindow) {
        guard let toastView = window.subviews.first else { return }

        UIView.animate(withDuration: 0.2, animations: {
            if toastView.tag == sn_topBar {
                toastView.frame.origin.y = -toastView.frame.height
            }
            toastView.alpha = 0
        }, completion: { _ in
            toastView.removeFromSuperview()
            window.isHidden = true
            if let index = windows.firstIndex(of: window) {
                windows.remove(at: index)
            }
            hideTasks[window]?.cancel()
            hideTasks.removeValue(forKey: window)
        })
    }

    /// 手动隐藏通知
    @objc static func hideNotice(_ sender: AnyObject) {
        if let window = sender as? UIWindow {
            hideWindow(window)
        }
    }
    
    /// 清空所有 Toast
    static func clearAllToast(callback: MCToastCallback? = nil) {
        DispatchQueue.main.safeSync {
            // 取消所有延迟任务
            for (_, task) in hideTasks {
                task.cancel()
            }
            hideTasks.removeAll()

            for window in windows {
                window.subviews.forEach { $0.removeFromSuperview() }
                window.isHidden = true
            }
            windows.removeAll()
        }
        callback?()
    }

    /// 自动移除 toast
    static func autoRemove(window: UIWindow, duration: CGFloat, callback: MCToastCallback?) {
        guard duration > 0 else { return }

        let task = DispatchWorkItem {
            if windows.contains(where: { $0 == window }) {
                hideWindow(window)
                callback?()
            }
        }

        hideTasks[window] = task
        DispatchQueue.main.asyncAfter(deadline: .now() + duration, execute: task)
    }
}

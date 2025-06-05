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


internal extension Selector {
    fileprivate static let hideNotice = #selector(MCToast.hideNotice(_:))
}

extension MCToast {
    
    /// 隐藏
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
        })
    }

    @objc static func hideNotice(_ sender: AnyObject) {
        if let window = sender as? UIWindow {
            hideWindow(window)
        }
    }
    
    
    /// 清空
    static func clearAllToast(callback: MCToastCallback? = nil) {
        DispatchQueue.main.safeSync {
            NSObject.cancelPreviousPerformRequests(withTarget: self)

            for window in windows {
                window?.subviews.forEach { $0.removeFromSuperview() }
                window?.isHidden = true
            }
            windows.removeAll()
        }
        callback?()
    }
}


extension MCToast {
    
    /// 自动隐藏
    static func autoRemove(window: UIWindow, duration: CGFloat, callback: MCToastCallback?) {
        let autoClear : Bool = duration > 0 ? true : false
        if autoClear {
            self.perform(.hideNotice, with: window, afterDelay: TimeInterval(duration))
             
            let time = DispatchTime.now() + .milliseconds(Int(duration * 1000))
            DispatchQueue.main.asyncAfter(deadline: time) {
                callback?()
            }
        }
    }
}

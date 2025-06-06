//
//  KeyboardManager.swift
//  MCToast
//
//  Created by qixin on 2025/6/6.
//

import Foundation
public class BTKeyboardManager {
    
    public static let shared = BTKeyboardManager()
    
    public private(set) var keyboardState: KeyboardState = .unknown
    
    public typealias KeyboardHeightChanged = (_ height: CGFloat, _ duration: CGFloat) -> Void

    
    public var keyboardHeightChanged: KeyboardHeightChanged?
    
    /// 上一次记录到的键盘有效高度（弹出时刷新)
    public private(set) var lastKnownKeyboardHeight: CGFloat?
    
    /// 当前键盘真实高度（动态获取，若键盘未展示则为 0）
    public var currentVisibleKeyboardHeight: CGFloat {

        if keyboardState.isVisible {
            return lastKnownKeyboardHeight ?? savedKeyboardHeight()
        }
        return 0
    }
    

    private init() {

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow(_:)),
                                               name: UIResponder.keyboardDidShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidHide(_:)),
                                               name: UIResponder.keyboardDidHideNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(onKeyboardWillChangeFrame),
                                               name: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        keyboardState = .willShow
                
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        if keyboardFrame.height > 0 {
            lastKnownKeyboardHeight = keyboardFrame.height
            UserDefaults.standard.set(Double(keyboardFrame.height), forKey: "toast.keyboard.height")
        }
    }
    
    @objc private func keyboardDidShow(_ notification: Notification) {
        keyboardState = .didShow
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        keyboardState = .willHide
    }
    
    @objc private func keyboardDidHide(_ notification: Notification) {
        keyboardState = .didHide
    }
    
    
    @objc private func onKeyboardWillChangeFrame(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let beginFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
              let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        // 如果 endFrame.minY > beginFrame.minY，说明键盘正在往下移（隐藏）；反之是弹出。
        let isHiding = beginFrame.minY < endFrame.minY
        
        let keyboardHeight = isHiding ? 0 : endFrame.height + 10
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0.25

        keyboardHeightChanged?(keyboardHeight, duration)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    /// 需要在键盘弹出前调用，执行init方法，提前监听通知。
    public func savedKeyboardHeight() -> CGFloat {
        let defaultHeight = UserDefaults.standard.double(forKey: "toast.keyboard.height")
        return max(defaultHeight, 216)
    }
}

extension BTKeyboardManager {
    public enum KeyboardState {
        case unknown
        case willShow
        case didShow
        case willHide
        case didHide
        
        /// 判断键盘当前是否可见
        var isVisible: Bool {
            switch self {
            case .willShow, .didShow:
                return true
            case .willHide, .didHide, .unknown:
                return false
            }
        }
    }
}

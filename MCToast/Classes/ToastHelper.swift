//
//  ToastHelper.swift
//  MCToast
//
//  Created by qixin on 2024/8/19.
//

import Foundation

//MARK: - 各种高度/宽度的获取
extension UIDevice {
    
    /// 顶部安全区域的高度 (20 / 44 / 47 / 59)
    static var topSafeAreaHeight: CGFloat {
        UIDevice.safeAreaInsets().top
    }
    
    /// 底部安全区域 (0 or 34)
    static var bottomSafeAreaHeight: CGFloat {
        UIDevice.safeAreaInsets().bottom
    }
}


//MARK: - 可以不关注。内部实现，为外部调用提供服务
extension UIDevice {
    
    fileprivate static func safeAreaInsets() -> (top: CGFloat, bottom: CGFloat) {
        
        // 既然是安全区域，非全面屏获取的虽然是0，但是毕竟有20高度的状态栏。也要空出来才可以不影响UI展示。
        let defalutArea: (CGFloat, CGFloat) = (20, 0)
        
        if #available(iOS 13.0, *) {
            let scene = UIApplication.shared.connectedScenes.first
            guard let windowScene = scene as? UIWindowScene else { return defalutArea }
            guard let window = windowScene.windows.first else { return defalutArea }
            let inset = window.safeAreaInsets
            
            return (inset.top, inset.bottom)
            
        } else if #available(iOS 11.0, *) {
            guard let window = UIApplication.shared.windows.first else { return defalutArea }
            let inset = window.safeAreaInsets
            return (inset.top, inset.bottom)
            
        } else {
            return defalutArea
        }
    }
}
extension UIEdgeInsets {
    var horizontal: CGFloat {
        return self.left + self.right
    }
    
    var vertical: CGFloat {
        return self.top + self.bottom
    }
}

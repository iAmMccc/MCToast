//
//  ToastHelper.swift
//  MCToast
//
//  Created by qixin on 2024/8/19.
//

import Foundation

class BundleImage {

    static func loadImage(named: String) -> UIImage? {
        let bundlePath = Bundle.init(for: BundleImage.self).path(forResource: "ToastBundle", ofType: "bundle") ?? ""
        
        let bundle = Bundle(path: bundlePath)
        
        let image = UIImage.loadImage(named, inBundle: bundle)
        return image
    }
}

extension UIImage {
    
    
    /// 加载图片资源（从Images.xcassets加载图片）
    /// - Parameters:
    ///   - name: 图片名称
    ///   - bundle: 图片所在的bundle
    /// - Returns: UIImage?
    static func loadImage(_ name: String, inBundle bundle: Bundle?) -> UIImage? {
        if #available(iOS 13, *) {
            let image = UIImage.init(named: name, in: bundle, with: nil)
            return image
        } else {
            
            let image = UIImage.init(named: name, in: bundle, compatibleWith: nil)
            return image
        }
    }
}


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
        
        let scene = UIApplication.shared.connectedScenes.first
        guard let windowScene = scene as? UIWindowScene else { return defalutArea }
        guard let window = windowScene.windows.first else { return defalutArea }
        let inset = window.safeAreaInsets
        
        return (inset.top, inset.bottom)
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


extension DispatchQueue {
    
    /// 确保切换主线程安全
    func safeSync(_ block: ()->()) {
        if self === DispatchQueue.main && Thread.isMainThread {
            block()
        } else {
            sync { block() }
        }
    }
}


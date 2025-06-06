//
//  ToastWindow.swift
//  MCToast
//
//  Created by qixin on 2025/6/5.
//

import Foundation


class ToastWindow: UIWindow {
    
    var mainView: ToastContentView
    
    var response: MCToast.RespondPolicy


    // 自定义构造器，增加 mainView 参数
    init(windowScene: UIWindowScene, mainView: ToastContentView, response: MCToast.RespondPolicy) {
        self.response = response
        self.mainView = mainView
        
        super.init(windowScene: windowScene)
        
        addSubview(mainView)
        
        isHidden = false
        windowLevel = .statusBar + 1
        backgroundColor = .clear
        
        // 如果不设置，将无法使用现代 UIKit 的很多功能（比如自动旋转支持、键盘避让、响应链传递等）
        rootViewController = UIViewController()
        rootViewController?.view.backgroundColor = .clear
    }



    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // 判断是否可以响应点击
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
       
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

//
//  MCToast+Custom.swift
//  BTMaterial
//
//  Created by qixin on 2022/12/8.
//

import Foundation

extension MCToast {
    
}
// MARK: - 展示各种状态Toast
extension MCToast {
    
    @discardableResult
    public static func showCustomView(_ customView: UIView,
                                      duration: CGFloat,
                                      bgColor: UIColor? = nil,
                                      respond: RespondPolicy,
                               callback: DismissHandler? = nil) -> UIWindow? {
        shared.showCustomView(customView, duration: duration, bgColor: bgColor, respond: respond, callback: callback)
    }
    
    
    @discardableResult
    func showCustomView(_ customView: UIView,
                                      duration: CGFloat,
                                      bgColor: UIColor? = nil,
                                      respond: RespondPolicy,
                                      callback: DismissHandler? = nil) -> UIWindow? {
        
        func getWindow() -> UIWindow? {

            // 创建窗口
            let window = createWindow(respond: respond, style: .custom)
            if let color = bgColor {
                window.mainView.backgroundColor = color
            }
           
            // 把 customView 加到 mainView 上
            window.mainView.addSubview(customView)
            
            // 设置 customView 尺寸约束（固定尺寸）
            NSLayoutConstraint.activate([
                customView.widthAnchor.constraint(equalToConstant: customView.frame.width),
                customView.heightAnchor.constraint(equalToConstant: customView.frame.height),
                customView.centerXAnchor.constraint(equalTo: window.mainView.centerXAnchor),
                customView.centerYAnchor.constraint(equalTo: window.mainView.centerYAnchor)
            ])
            
            // mainView 尺寸等于 customView
            NSLayoutConstraint.activate([
                window.mainView.widthAnchor.constraint(equalToConstant: customView.frame.width),
                window.mainView.heightAnchor.constraint(equalToConstant: customView.frame.height)
            ])
            
            // mainView 居中约束
            let centerX = window.mainView.centerXAnchor.constraint(equalTo: window.centerXAnchor)
            let centerY = window.mainView.centerYAnchor.constraint(equalTo: window.centerYAnchor)
            
            NSLayoutConstraint.activate([centerX, centerY])
            
            // 保证 window 会布局约束
            window.layoutIfNeeded()
            
            
            autoRemove(window: window, duration: duration, callback: callback)
            
            return window
        }
        
        guard !customView.frame.size.equalTo(.zero) else {
            assertionFailure("customView 必须有确定的尺寸 frame")
            return nil
        }
        
        var tempWindow: UIWindow?
        DispatchQueue.main.safeSync {
            clearAllToast()
            tempWindow = getWindow()
        }
        return tempWindow
    }
}

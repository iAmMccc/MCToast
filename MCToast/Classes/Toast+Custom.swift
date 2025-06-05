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
                                      respond: MCToast.MCToastRespond,
                                      callback: MCToast.MCToastCallback? = nil) -> UIWindow? {
        
        func createWindow() -> UIWindow? {
            // 创建窗口
            let window = MCToast.createWindow(respond: respond, isLandscape: false, size: customView.frame.size, toastType: .icon)
            
            // 创建承载视图
            let mainView = MCToast.createMainView(bgColor: bgColor)
            mainView.translatesAutoresizingMaskIntoConstraints = false
            
            // 把 customView 加到 mainView 上
            customView.translatesAutoresizingMaskIntoConstraints = false
            mainView.addSubview(customView)
            
            window.addSubview(mainView)
            
            // 设置 customView 尺寸约束（固定尺寸）
            NSLayoutConstraint.activate([
                customView.widthAnchor.constraint(equalToConstant: customView.frame.width),
                customView.heightAnchor.constraint(equalToConstant: customView.frame.height),
                customView.centerXAnchor.constraint(equalTo: mainView.centerXAnchor),
                customView.centerYAnchor.constraint(equalTo: mainView.centerYAnchor)
            ])
            
            // mainView 尺寸等于 customView
            NSLayoutConstraint.activate([
                mainView.widthAnchor.constraint(equalToConstant: customView.frame.width),
                mainView.heightAnchor.constraint(equalToConstant: customView.frame.height)
            ])
            
            // mainView 居中约束
            let centerX = mainView.centerXAnchor.constraint(equalTo: window.centerXAnchor)
            var centerY = mainView.centerYAnchor.constraint(equalTo: window.centerYAnchor)
            
            // 如果需要响应导航栏，则向上偏移一部分
            if respond == .allowNav, let vc = UIViewController.current() {
                let navBarHeight = vc.navigationController?.navigationBar.frame.maxY ?? 0
                centerY = mainView.centerYAnchor.constraint(equalTo: window.centerYAnchor, constant: -navBarHeight/2)
            }
            
            NSLayoutConstraint.activate([centerX, centerY])
            
            // 保证 window 会布局约束
            window.layoutIfNeeded()
            
            windows.append(window)
            MCToast.autoRemove(window: window, duration: duration, callback: callback)
            
            return window
        }
        
        guard !customView.frame.size.equalTo(.zero) else {
            assertionFailure("customView 必须有确定的尺寸 frame")
            return nil
        }
        
        var tempWindow: UIWindow?
        DispatchQueue.main.safeSync {
            clearAllToast()
            tempWindow = createWindow()
        }
        return tempWindow
    }
}

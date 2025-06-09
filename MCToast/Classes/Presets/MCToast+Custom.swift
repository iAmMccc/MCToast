//
//  MCToast+Custom.swift
//  BTMaterial
//
//  Created by qixin on 2022/12/8.
//

import Foundation

// MARK: - 展示各种状态Toast
extension MCToast {
    
    @discardableResult
    func showCustomView(
        _ customView: UIView,
        duration: CGFloat,
        respond: RespondPolicy,
        showHander: ShowHandler? = nil,
        dismissHandler: DismissHandler? = nil
    ) -> UIWindow? {
        
        func getWindow() -> UIWindow? {
            
            let size = customView.frame.size
            
            // 创建窗口
            let window = createWindow(respond: respond, style: .custom, size: size)
            
            // 把 customView 加到 contentView 上
            window.contentView.addSubview(customView)
            
            // 设置 customView 尺寸约束（固定尺寸）
            NSLayoutConstraint.activate([
                customView.widthAnchor.constraint(equalToConstant: size.width),
                customView.heightAnchor.constraint(equalToConstant: size.height),
                customView.centerXAnchor.constraint(equalTo: window.contentView.centerXAnchor),
                customView.centerYAnchor.constraint(equalTo: window.contentView.centerYAnchor)
            ])
            
            // 保证 window 会布局约束
            window.layoutIfNeeded()
            
            manageLifecycle(window: window, duration: duration, showHandler: showHander, dismissHandler: dismissHandler)

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

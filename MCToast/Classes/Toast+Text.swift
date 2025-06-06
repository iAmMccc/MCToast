//
//  MCToast+Text.swift
//  MCToast
//
//  Created by Mccc on 2020/6/24.
//


extension UIResponder {
    
    /// 展示文字toast
    /// - Parameters:
    ///   - text: 文字内容
    ///   - offset: toast底部距离屏幕底部距离
    ///   - duration: 显示的时间（秒）
    ///   - respond: 交互类型
    ///   - callback: 隐藏的回调
    @discardableResult
    public func mc_text(_ text: String,
                        offset: CGFloat = MCToastConfig.shared.text.offset,
                        duration: CGFloat = MCToastConfig.shared.duration,
                        respond: MCToast.MCToastRespond = MCToastConfig.shared.respond,
                        callback: MCToast.MCToastCallback? = nil) -> UIWindow?  {
        return MCToast.mc_text(text, offset: offset, duration: duration, respond: respond, callback: callback)
    }
}


extension MCToast {
    
    
    /// 展示文字toast
    /// - Parameters:
    ///   - text: 文字内容
    ///   - offset: toast底部距离屏幕底部距离
    ///   - duration: 显示的时间（秒）
    ///   - respond: 交互类型
    ///   - callback: 隐藏的回调
    @discardableResult
    public static func mc_text(_ text: String,
                               offset: CGFloat = MCToastConfig.shared.text.offset,
                               duration: CGFloat = MCToastConfig.shared.duration,
                               respond: MCToast.MCToastRespond = MCToastConfig.shared.respond,
                               callback: MCToast.MCToastCallback? = nil) -> UIWindow? {
        return MCToast.shared.showText(text, offset: offset, duration: duration, respond: respond, callback: callback)
        
    }
    
}


// MARK: - 显示纯文字
extension MCToast {
    
    @discardableResult
    internal func showText(_ text: String,
                                  offset: CGFloat = MCToastConfig.shared.text.offset,
                                  duration: CGFloat,
                                  respond: MCToast.MCToastRespond,
                                  callback: MCToast.MCToastCallback? = nil) -> UIWindow? {
        
        func createLabel() -> UILabel {
            let label = UILabel()
            label.text = text
            label.numberOfLines = 0
            label.font = MCToastConfig.shared.text.font
            label.textAlignment = .center
            label.textColor = MCToastConfig.shared.text.textColor
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }
        
        func getWindow() -> UIWindow {
            /// 1. 创建label
            let mainLabel = createLabel()
            
            /// 2. 生成mainView
            let mainView = createMainView()
            mainView.translatesAutoresizingMaskIntoConstraints = false
            
            /// 2. 生成window
            let window = createWindow(respond: respond, mainView: mainView)
            
            /// 4. 添加mainView到window
            window.addSubview(mainView)
            
            /// 5. 添加label到mainView
            mainView.addSubview(mainLabel)
            
            /// 6. mainView 约束
            switch respond {
            case .allow:
                // 让mainView大小刚好包裹label内容
                // 先给个宽最大限制，防止太宽
                let maxWidth = MCToastConfig.shared.text.maxWidth + MCToastConfig.shared.text.padding.horizontal
                
                NSLayoutConstraint.activate([
                    mainView.centerXAnchor.constraint(equalTo: window.centerXAnchor),
                    // 限制最大宽度
                    mainView.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth)
                ])
                
                var bottomConstraint: NSLayoutConstraint
                if KeyboardManager.shared.currentVisibleKeyboardHeight > 0 {
                    let bottomOffset = -KeyboardManager.shared.currentVisibleKeyboardHeight - 10
                    bottomConstraint = mainView.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: bottomOffset)
                } else {
                    let bottomOffset = -offset
                    bottomConstraint = mainView.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: bottomOffset)
                }
                bottomConstraint.isActive = true
                self.toastWindow?.mainView?.bottomConstraint = bottomConstraint

                
            case .allowNav, .forbid:
                NSLayoutConstraint.activate([
                    mainView.centerXAnchor.constraint(equalTo: window.centerXAnchor),
                    mainView.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: -offset),
                    // 这里可以不限制宽度，或者根据实际需求限制
                    mainView.widthAnchor.constraint(lessThanOrEqualToConstant: MCToastConfig.shared.text.maxWidth + MCToastConfig.shared.text.padding.horizontal)
                ])
            }
            
            /// 7. label 约束 - 填满mainView，留padding间距
            NSLayoutConstraint.activate([
                mainLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: MCToastConfig.shared.text.padding.top),
                mainLabel.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: MCToastConfig.shared.text.padding.left),
                mainLabel.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -MCToastConfig.shared.text.padding.right),
                mainLabel.bottomAnchor.constraint(equalTo: mainView.bottomAnchor, constant: -MCToastConfig.shared.text.padding.bottom)
            ])
            
            
            autoRemove(window: window, duration: duration, callback: callback)
            
            return window
        }
        
        if text.isEmpty { return nil }
        
        var temp: UIWindow?
        DispatchQueue.main.safeSync {
            clearAllToast()
            temp = getWindow()
        }
        return temp
    }
}

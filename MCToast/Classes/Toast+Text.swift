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
        return MCToast.showText(text, offset: offset, duration: duration, respond: respond, callback: callback)
        
    }
    
}


// MARK: - 显示纯文字
extension MCToast {
    
    @discardableResult
    internal static func showText(_ text: String,
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
        
        func createWindow() -> UIWindow {
            /// 1. 创建label
            let mainLabel = createLabel()
            
            /// 2. 生成window
            // 这里暂时给一个全屏大小，后面用约束定位mainView和label
            let window = MCToast.createWindow(respond: respond, size: UIScreen.main.bounds.size, toastType: .text, offset: offset)
            

            
            /// 3. 生成mainView
            let mainView = MCToast.createMainView()
            mainView.translatesAutoresizingMaskIntoConstraints = false
            
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
                    // 竖直方向放到底部，距离屏幕底部offset
                    mainView.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: -offset),
                    // 限制最大宽度
                    mainView.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth)
                ])
                
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
            
            windows.append(window)
            
            MCToast.autoRemove(window: window, duration: duration, callback: callback)
            
            return window
        }
        
        if text.isEmpty { return nil }
        
        var temp: UIWindow?
        DispatchQueue.main.safeSync {
            clearAllToast()
            temp = createWindow()
        }
        return temp
    }
}

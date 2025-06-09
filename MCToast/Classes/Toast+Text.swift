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
    public func text(_ text: String,
                        offset: CGFloat = MCToastConfig.shared.text.offset,
                        duration: CGFloat = MCToastConfig.shared.duration,
                        respond: MCToast.RespondPolicy = MCToastConfig.shared.respond,
                        dismissHandler: MCToast.DismissHandler? = nil) -> UIWindow?  {
        return MCToast.text(text, offset: offset, duration: duration, respond: respond, dismissHandler: dismissHandler)
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
    public static func text(_ text: String,
                               offset: CGFloat = MCToastConfig.shared.text.offset,
                               duration: CGFloat = MCToastConfig.shared.duration,
                               respond: RespondPolicy = MCToastConfig.shared.respond,
                               dismissHandler: DismissHandler? = nil) -> UIWindow? {
        return MCToast.shared.showText(text, offset: offset, duration: duration, respond: respond, dismissHandler: dismissHandler)
        
    }
    
}


// MARK: - 显示纯文字
extension MCToast {
    
    @discardableResult
    internal func showText(_ text: String,
                                  offset: CGFloat = MCToastConfig.shared.text.offset,
                                  duration: CGFloat,
                                  respond: RespondPolicy,
                           dismissHandler: DismissHandler? = nil) -> UIWindow? {
        
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

            /// 1. 生成window
            let window = createWindow(respond: respond, style: .text, offset: offset)
            
            /// 2. 创建label
            let mainLabel = createLabel()
            
            /// 3. 添加label到contentView
            window.contentView.addSubview(mainLabel)
                        
            /// 4. label 约束 - 填满contentView，留padding间距
            NSLayoutConstraint.activate([
                mainLabel.topAnchor.constraint(equalTo: window.contentView.topAnchor, constant: MCToastConfig.shared.text.padding.top),
                mainLabel.leadingAnchor.constraint(equalTo: window.contentView.leadingAnchor, constant: MCToastConfig.shared.text.padding.left),
                mainLabel.trailingAnchor.constraint(equalTo: window.contentView.trailingAnchor, constant: -MCToastConfig.shared.text.padding.right),
                mainLabel.bottomAnchor.constraint(equalTo: window.contentView.bottomAnchor, constant: -MCToastConfig.shared.text.padding.bottom)
            ])
            
            
            autoRemove(window: window, duration: duration, dismissHandler: dismissHandler)
            
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

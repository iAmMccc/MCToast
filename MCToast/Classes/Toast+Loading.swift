//
//  MCToast+Loading.swift
//  MCToast
//
//  Created by Mccc on 2020/6/24.
//




/**
 loading 里面新增
 
 1. 帧动画
 2. json动画
 3. 系统loading
 4. 是否需要文字提示
 5. 如何动态更新文字 （比如上传图片的数量的改动）
 6. 
 */

extension UIResponder {
    
    
    /// loading (菊花)
    /// - Parameters:
    ///   - text: 显示的内容
    ///   - duration: 持续时间
    ///   - respond: 交互方式
    ///   - callback: 隐藏回调
    @discardableResult
    public func mc_loading(text: String = "正在加载中",
                           duration: CGFloat = 0,
                           respond: MCToast.RespondPolicy = MCToastConfig.shared.respond,
                           dismissHandler: MCToast.DismissHandler? = nil) -> UIWindow? {
        if text.isEmpty {
            return MCToast.shared.loading(duration: duration, respond: respond, dismissHandler: dismissHandler)
        } else {
            return MCToast.shared.loading(text: text, duration: duration, respond: respond, dismissHandler: dismissHandler)
        }
    }
}


extension MCToast {
    
    /// loading (菊花)
    ///
    /// - Parameters:
    ///   - text: 文字内容 默认为 "正在加载中"
    ///   - duration: 自动隐藏的时间
    ///   - font: 字体大小
    @discardableResult
    public static func mc_loading(text: String = "正在加载中",
                                  duration: CGFloat = 0,
                                  respond: RespondPolicy = MCToastConfig.shared.respond,
                                  dismissHandler: DismissHandler? = nil) -> UIWindow? {
        
        if text.isEmpty {
            return MCToast.shared.loading(duration: duration, respond: respond, dismissHandler: dismissHandler)
        } else {
            return MCToast.shared.loading(text: text, duration: duration, respond: respond, dismissHandler: dismissHandler)
        }
    }
}

extension MCToast {
    @discardableResult
    fileprivate func loading(text: String? = nil,
                                    duration: CGFloat,
                                    respond: RespondPolicy,
                             dismissHandler: DismissHandler? = nil) -> UIWindow? {
        
        func getWindow() -> UIWindow {
            let window = createWindow(respond: respond, style: .loading)
                        
            let activity = UIActivityIndicatorView()
            activity.translatesAutoresizingMaskIntoConstraints = false
            if #available(iOS 13.0, *) {
                activity.style = .large
            } else {
                activity.style = .whiteLarge
            }
            activity.startAnimating()
            window.mainView.addSubview(activity)
            
            // 只有纯 icon（不含文字）
            guard let text = text, !text.isEmpty else {
                activity.color = .black
                window.mainView.backgroundColor = UIColor.clear
                NSLayoutConstraint.activate([
                    activity.centerXAnchor.constraint(equalTo: window.mainView.centerXAnchor),
                    activity.centerYAnchor.constraint(equalTo: window.mainView.centerYAnchor),
                    activity.widthAnchor.constraint(equalToConstant: MCToastConfig.shared.icon.imageSize.width),
                    activity.heightAnchor.constraint(equalToConstant: MCToastConfig.shared.icon.imageSize.height),
                    window.mainView.heightAnchor.constraint(equalToConstant: MCToastConfig.shared.icon.imageSize.height + MCToastConfig.shared.icon.padding.vertical)
                ])
                return window
            }
            
            activity.color = .white

            // 含文字的样式
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = MCToastConfig.shared.icon.font
            label.textColor = MCToastConfig.shared.icon.textColor
            label.text = text
            label.numberOfLines = 2
            label.textAlignment = .center
            label.lineBreakMode = .byCharWrapping
            window.mainView.addSubview(label)
            
            NSLayoutConstraint.activate([
                activity.topAnchor.constraint(equalTo: window.mainView.topAnchor, constant: MCToastConfig.shared.icon.padding.top),
                activity.centerXAnchor.constraint(equalTo: window.mainView.centerXAnchor),
                activity.widthAnchor.constraint(equalToConstant: MCToastConfig.shared.icon.imageSize.width),
                activity.heightAnchor.constraint(equalToConstant: MCToastConfig.shared.icon.imageSize.height),
                
                label.topAnchor.constraint(equalTo: activity.bottomAnchor, constant: 12),
                label.leadingAnchor.constraint(equalTo: window.mainView.leadingAnchor, constant: MCToastConfig.shared.icon.padding.left),
                label.trailingAnchor.constraint(equalTo: window.mainView.trailingAnchor, constant: -MCToastConfig.shared.icon.padding.right),
                label.bottomAnchor.constraint(equalTo: window.mainView.bottomAnchor, constant: -MCToastConfig.shared.icon.padding.bottom)
            ])
            autoRemove(window: window, duration: duration, dismissHandler: dismissHandler)
            return window
        }
        var tempWindow: UIWindow?
        DispatchQueue.main.safeSync {
            clearAllToast()
            tempWindow = getWindow()
        }
        return tempWindow
    }
}

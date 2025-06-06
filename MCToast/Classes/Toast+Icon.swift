//
//  MCToast+Icon.swift
//  MCToast
//
//  Created by Mccc on 2020/6/24.
//



extension UIResponder {
    
    /// 成功类型的Toast
    /// - Parameters:
    ///   - text: 文字内容
    ///   - duration: 展示时间（秒）
    ///   - respond: 交互类型
    ///   - callback: 隐藏的回调
    @discardableResult
    public func mc_success(_ text:String,
                           duration: CGFloat = MCToastConfig.shared.duration,
                           respond: MCToast.RespondPolicy = MCToastConfig.shared.respond,
                           callback: MCToast.DismissHandler? = nil) -> UIWindow? {
        return MCToast.mc_success(text, duration: duration, respond: respond, callback: callback)
    }
    
    
    /// 失败类型的Toast
    /// - Parameters:
    ///   - text: 文字内容
    ///   - duration: 展示时间（秒）
    ///   - respond: 交互类型
    ///   - callback: 隐藏的回调
    @discardableResult
    public func mc_failure(_ text: String,
                           duration:CGFloat = MCToastConfig.shared.duration,
                           respond: MCToast.RespondPolicy = MCToastConfig.shared.respond,
                           callback: MCToast.DismissHandler? = nil) -> UIWindow? {
        return MCToast.mc_failure(text, duration: duration, respond: respond, callback: callback)
    }
    
    
    /// 警告类型的Toast
    /// - Parameters:
    ///   - text: 文字内容
    ///   - duration: 展示时间（秒）
    ///   - respond: 交互类型
    ///   - callback: 隐藏的回调
    @discardableResult
    public func mc_warning(_ text: String,
                           duration:CGFloat = MCToastConfig.shared.duration,
                           respond: MCToast.RespondPolicy = MCToastConfig.shared.respond,
                           callback: MCToast.DismissHandler? = nil) -> UIWindow? {
        return MCToast.mc_warning(text, duration: duration, respond: respond, callback: callback)
    }
}



extension MCToast {
    
    /// 成功类型的Toast
    /// - Parameters:
    ///   - text: 文字内容
    ///   - duration: 展示时间（秒）
    ///   - respond: 交互类型
    ///   - callback: 隐藏的回调
    @discardableResult
    public static func mc_success(_ text:String,
                                  duration: CGFloat = MCToastConfig.shared.duration,
                                  respond: RespondPolicy = MCToastConfig.shared.respond,
                                  callback: DismissHandler? = nil) -> UIWindow? {
        
        return MCToast.showStatus(text: text, iconImage: IconType.success.getImage(), duration: duration, respond: respond, callback: callback)
    }
    
    
    /// 失败类型的Toast
    /// - Parameters:
    ///   - text: 文字内容
    ///   - duration: 展示时间（秒）
    ///   - respond: 交互类型
    ///   - callback: 隐藏的回调
    @discardableResult
    public static func mc_failure(_ text: String,
                                  duration:CGFloat = MCToastConfig.shared.duration,
                                  respond: RespondPolicy = MCToastConfig.shared.respond,
                                  callback: DismissHandler? = nil) -> UIWindow?  {
        return MCToast.showStatus(text: text, iconImage: IconType.failure.getImage(), duration: duration, respond: respond, callback: callback)
    }
    
    
    /// 警告类型的Toast
    /// - Parameters:
    ///   - text: 文字内容
    ///   - duration: 展示时间（秒）
    ///   - respond: 交互类型
    ///   - callback: 隐藏的回调
    @discardableResult
    public static func mc_warning(_ text: String,
                                  duration: CGFloat = MCToastConfig.shared.duration,
                                  respond: RespondPolicy = MCToastConfig.shared.respond,
                                  callback: DismissHandler? = nil) -> UIWindow? {
        return MCToast.showStatus(text: text, iconImage: IconType.warning.getImage(), duration: duration, respond: respond,callback: callback)
    }
    
    
    
    @discardableResult
    public static func showStatus(text: String,
                    iconImage: UIImage?,
                    duration: CGFloat,
                    respond: RespondPolicy,
                                  callback: DismissHandler? = nil) -> UIWindow? {
        shared.showStatus(text: text, iconImage: iconImage, duration: duration, respond: respond, callback: callback)
    }
}


// MARK: - 展示各种状态Toast
extension MCToast {
    
    /// 加载图片资源
    static func loadImage(_ name: String) -> UIImage? {
        let image = BundleImage.loadImage(named: name)
        return image
    }
    
    @discardableResult
    func showStatus(text: String,
                    iconImage: UIImage?,
                    duration: CGFloat,
                    respond: RespondPolicy,
                    callback: DismissHandler? = nil) -> UIWindow? {

        func getWindow() -> UIWindow? {
            
            // 创建主 Toast Window
            let window = createWindow(respond: respond, style: .icon)

            NSLayoutConstraint.activate([
                window.mainView.centerXAnchor.constraint(equalTo: window.centerXAnchor),
                window.mainView.centerYAnchor.constraint(equalTo: window.centerYAnchor),
                window.mainView.widthAnchor.constraint(equalToConstant: MCToastConfig.shared.icon.toastWidth)
            ])

            // 图标
            let icon = UIImageView(image: iconImage)
            icon.translatesAutoresizingMaskIntoConstraints = false
            window.mainView.addSubview(icon)

            // 文字
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = MCToastConfig.shared.icon.font
            label.textColor = MCToastConfig.shared.icon.textColor
            label.text = text
            label.numberOfLines = 2
            label.lineBreakMode = .byCharWrapping
            label.textAlignment = .center
            window.mainView.addSubview(label)

            let padding = MCToastConfig.shared.icon.padding
            let imageSize = MCToastConfig.shared.icon.imageSize

            NSLayoutConstraint.activate([
                icon.topAnchor.constraint(equalTo: window.mainView.topAnchor, constant: padding.top),
                icon.centerXAnchor.constraint(equalTo: window.mainView.centerXAnchor),
                icon.widthAnchor.constraint(equalToConstant: imageSize.width),
                icon.heightAnchor.constraint(equalToConstant: imageSize.height),

                label.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 12),
                label.leftAnchor.constraint(equalTo: window.mainView.leftAnchor, constant: padding.left),
                label.rightAnchor.constraint(equalTo: window.mainView.rightAnchor, constant: -padding.right),
                label.bottomAnchor.constraint(equalTo: window.mainView.bottomAnchor, constant: -padding.bottom)
            ])

            autoRemove(window: window, duration: duration, callback: callback)
            return window
        }

        guard !text.isEmpty else { return nil }

        var temp: UIWindow?
        DispatchQueue.main.safeSync {
            clearAllToast()
            temp = getWindow()
        }
        return temp
    }
}


extension MCToast {
    /// Toast类型
    public enum IconType {
        /// 成功
        case success
        /// 失败
        case failure
        /// 警告
        case warning
        
        func getImage() -> UIImage? {
            var showImage: UIImage?
            switch self {
            case .success:
                if let trueImage = MCToastConfig.shared.icon.successImage {
                    showImage = trueImage
                } else {
                    showImage = MCToast.loadImage("toast_success")
                }
            case .failure:
                if let trueImage = MCToastConfig.shared.icon.failureImage {
                    showImage = trueImage
                } else {
                    showImage = MCToast.loadImage("toast_failure")
                }
            case .warning:
                if let trueImage = MCToastConfig.shared.icon.warningImage {
                    showImage = trueImage
                } else {
                    showImage = MCToast.loadImage("toast_warning")
                }
            }
            return showImage
        }
    }
}

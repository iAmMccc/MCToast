//
//  MCToast+Icon.swift
//  MCToast
//
//  Created by Mccc on 2020/6/24.
//

// MARK: - 展示各种状态Toast
extension MCToast {
    
    /// 加载图片资源
    static func loadImage(_ name: String) -> UIImage? {
        let image = BundleImage.loadImage(named: name)
        return image
    }
    
    @discardableResult
    func showStatus(
        text: String,
        iconImage: UIImage?,
        duration: CGFloat,
        respond: RespondPolicy,
        dismissHandler: DismissHandler? = nil
    ) -> UIWindow? {
        
        func getWindow() -> UIWindow? {
            
            // 创建主 Toast Window
            let window = createWindow(respond: respond, style: .icon)
            
            
            // 图标
            let icon = UIImageView(image: iconImage)
            icon.translatesAutoresizingMaskIntoConstraints = false
            window.contentView.addSubview(icon)
            
            // 文字
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = MCToastConfig.shared.icon.font
            label.textColor = MCToastConfig.shared.icon.textColor
            label.text = text
            label.numberOfLines = 2
            label.lineBreakMode = .byCharWrapping
            label.textAlignment = .center
            window.contentView.addSubview(label)
            
            let padding = MCToastConfig.shared.icon.padding
            let imageSize = MCToastConfig.shared.icon.imageSize
            
            NSLayoutConstraint.activate([
                icon.topAnchor.constraint(equalTo: window.contentView.topAnchor, constant: padding.top),
                icon.centerXAnchor.constraint(equalTo: window.contentView.centerXAnchor),
                icon.widthAnchor.constraint(equalToConstant: imageSize.width),
                icon.heightAnchor.constraint(equalToConstant: imageSize.height),
                
                label.topAnchor.constraint(equalTo: icon.bottomAnchor, constant: 12),
                label.leftAnchor.constraint(equalTo: window.contentView.leftAnchor, constant: padding.left),
                label.rightAnchor.constraint(equalTo: window.contentView.rightAnchor, constant: -padding.right),
                label.bottomAnchor.constraint(equalTo: window.contentView.bottomAnchor, constant: -padding.bottom),
            ])
            
            autoRemove(window: window, duration: duration, dismissHandler: dismissHandler)
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


extension MCToast.IconType {
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

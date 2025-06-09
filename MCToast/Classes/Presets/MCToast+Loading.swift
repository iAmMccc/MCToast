//
//  MCToast+Loading.swift
//  MCToast
//
//  Created by Mccc on 2020/6/24.
//




extension MCToast {
    @discardableResult
    func loading(
        text: String? = nil,
        duration: CGFloat,
        respond: RespondPolicy,
        dismissHandler: DismissHandler? = nil
    ) -> UIWindow? {
        
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
            window.contentView.addSubview(activity)
            
            // 只有纯 icon（不含文字）
            guard let text = text, !text.isEmpty else {
                activity.color = .black
                window.contentView.backgroundColor = UIColor.clear
                NSLayoutConstraint.activate([
                    activity.centerXAnchor.constraint(equalTo: window.contentView.centerXAnchor),
                    activity.centerYAnchor.constraint(equalTo: window.contentView.centerYAnchor),
                    activity.widthAnchor.constraint(equalToConstant: MCToastConfig.shared.icon.imageSize.width),
                    activity.heightAnchor.constraint(equalToConstant: MCToastConfig.shared.icon.imageSize.height),
                    window.contentView.heightAnchor.constraint(equalToConstant: MCToastConfig.shared.icon.imageSize.height + MCToastConfig.shared.icon.padding.vertical)
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
            window.contentView.addSubview(label)
            
            NSLayoutConstraint.activate([
                activity.topAnchor.constraint(equalTo: window.contentView.topAnchor, constant: MCToastConfig.shared.icon.padding.top),
                activity.centerXAnchor.constraint(equalTo: window.contentView.centerXAnchor),
                activity.widthAnchor.constraint(equalToConstant: MCToastConfig.shared.icon.imageSize.width),
                activity.heightAnchor.constraint(equalToConstant: MCToastConfig.shared.icon.imageSize.height),
                
                label.topAnchor.constraint(equalTo: activity.bottomAnchor, constant: 12),
                label.leadingAnchor.constraint(equalTo: window.contentView.leadingAnchor, constant: MCToastConfig.shared.icon.padding.left),
                label.trailingAnchor.constraint(equalTo: window.contentView.trailingAnchor, constant: -MCToastConfig.shared.icon.padding.right),
                label.bottomAnchor.constraint(equalTo: window.contentView.bottomAnchor, constant: -MCToastConfig.shared.icon.padding.bottom)
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

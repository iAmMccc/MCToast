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
        showHander: ShowHandler? = nil,
        dismissHandler: DismissHandler? = nil
    ) -> UIWindow? {
        
        func getWindow() -> UIWindow {
            let window = createWindow(respond: respond, style: .loading, position: .center)
            
            let activity = UIActivityIndicatorView()
            activity.translatesAutoresizingMaskIntoConstraints = false
            activity.style = .large
            activity.color = .white

            activity.startAnimating()
            window.contentView.addSubview(activity)
            
            // 只有纯 icon（不含文字）
            guard let text = text, !text.isEmpty else {
                NSLayoutConstraint.activate([
                    activity.centerXAnchor.constraint(equalTo: window.contentView.centerXAnchor),
                    activity.centerYAnchor.constraint(equalTo: window.contentView.centerYAnchor),
                    activity.widthAnchor.constraint(equalToConstant: MCToastConfig.shared.icon.imageSize.width),
                    activity.heightAnchor.constraint(equalToConstant: MCToastConfig.shared.icon.imageSize.height),
                    window.contentView.heightAnchor.constraint(equalToConstant: MCToastConfig.shared.icon.imageSize.height + MCToastConfig.shared.icon.padding.vertical)
                ])
                return window
            }
            
            
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
            
            // 有文字时，背景默认显示
            window.contentView.backgroundColor = MCToastConfig.shared.background.resolvedColor
            
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
            manageLifecycle(window: window, duration: duration, showHandler: showHander, dismissHandler: dismissHandler)
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

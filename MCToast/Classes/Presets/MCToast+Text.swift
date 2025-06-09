//
//  MCToast+Text.swift
//  MCToast
//
//  Created by Mccc on 2020/6/24.
//


// MARK: - 显示纯文字
extension MCToast {
    
    @discardableResult
    internal func showText(
        _ text: String,
        position: Position,
        duration: CGFloat,
        respond: RespondPolicy,
        showHander: ShowHandler? = nil,
        dismissHandler: DismissHandler? = nil
    ) -> UIWindow? {
        
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
            let window = createWindow(respond: respond, style: .text, position: position)
            
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
            
            
            manageLifecycle(window: window, duration: duration, showHandler: showHander, dismissHandler: dismissHandler)

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

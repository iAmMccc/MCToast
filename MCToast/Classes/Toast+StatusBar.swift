//
//  MCToast+noticeBar.swift
//  MCToast
//
//  Created by Mccc on 2020/6/24.
//

import Foundation

extension UIResponder {
    
    /// 在状态栏栏显示一个toast
    /// - Parameters:
    ///   - text: 显示的文字内容
    ///   - duration: 显示的时长（秒）
    ///   - font: 文字字体
    ///   - backgroundColor: 背景颜色
    ///   - callback: 隐藏的回调
    @discardableResult
    public func mc_statusBar( _ text: String,
                              duration: CGFloat = MCToastConfig.shared.duration,
                              font: UIFont = MCToastConfig.shared.text.font,
                              backgroundColor: UIColor? = nil,
                              dismissHandler: MCToast.DismissHandler? = nil) -> UIWindow? {
        return MCToast.mc_statusBar(text, duration: duration, font: font, backgroundColor: backgroundColor, dismissHandler: dismissHandler)
    }
}


extension MCToast {
    
    /// 在状态栏栏显示一个toast
    /// - Parameters:
    ///   - text: 显示的文字内容
    ///   - duration: 显示的时长（秒）
    ///   - font: 文字字体
    ///   - backgroundColor: 背景颜色
    ///   - callback: 隐藏的回调
    @discardableResult
    public static func mc_statusBar(
        _ text: String,
        duration: CGFloat = MCToastConfig.shared.duration,
        font: UIFont = MCToastConfig.shared.text.font,
        backgroundColor: UIColor? = nil,
        dismissHandler: DismissHandler? = nil) -> UIWindow? {
            return MCToast.shared.noticeOnStatusBar(text, duration: duration, backgroundColor: backgroundColor, font: font, dismissHandler: dismissHandler)
        }
}



// MARK: - 在状态栏上显示提示框
extension MCToast {
    
    @discardableResult
    internal func noticeOnStatusBar(
        _ text: String,
        duration: CGFloat,
        backgroundColor: UIColor?,
        font: UIFont,
        dismissHandler: DismissHandler? = nil
    ) -> UIWindow? {
        
        guard !text.isEmpty else { return nil }

        func getWindow() -> UIWindow {
            clearAllToast()

            let window = createWindow(respond: .allow, style: .statusBar)

            let containerView = ToastContentView()
            containerView.backgroundColor = backgroundColor ?? UIColor(red: 0x6a/255.0, green: 0xb4/255.0, blue: 0x9f/255.0, alpha: 1)
            containerView.tag = sn_topBar
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.textAlignment = .center
            label.font = font
            label.textColor = .white
            label.text = text
            label.numberOfLines = 0
            containerView.addSubview(label)

            window.contentView = containerView

            let topSafeArea = UIDevice.topSafeAreaHeight
            let labelPadding: CGFloat = 5.0

            // 添加约束
            NSLayoutConstraint.activate([
                // containerView 约束
                containerView.leadingAnchor.constraint(equalTo: window.leadingAnchor),
                containerView.trailingAnchor.constraint(equalTo: window.trailingAnchor),
                containerView.topAnchor.constraint(equalTo: window.topAnchor),
                containerView.heightAnchor.constraint(equalToConstant: topSafeArea + 44),

                // label 约束（放在 safeArea 下方）
                label.topAnchor.constraint(equalTo: containerView.topAnchor, constant: topSafeArea + labelPadding),
                label.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
                label.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
                label.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -labelPadding)
            ])
            

            // 动画滑入
            UIView.animate(withDuration: 0.3, animations: {
                window.frame.origin.y = 0
            }, completion: { _ in
                self.autoRemove(window: window, duration: duration, dismissHandler: dismissHandler)
            })

            return window
        }

        var result: UIWindow?
        DispatchQueue.main.safeSync {
            result = getWindow()
        }
        return result
    }
}

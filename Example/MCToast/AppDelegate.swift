//
//  AppDelegate.swift
//  MCToast
//
//  Created by Mccc on 11/25/2019.
//  Copyright (c) 2019 Mccc. All rights reserved.
//

import UIKit
import MCToast

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIApplication.shared.statusBarStyle = .lightContent

        MCToast.enableKeyboardTracking()
        MCToast.enableOrientationTracking()

        // 设置通配类型
        configToast()
        
        // 延迟调用，等布局完成
        DispatchQueue.main.async {
            self.window?.addCrosshairLines()
        }
        
        return true
    }
}



extension AppDelegate {
    func configToast() {
        
        /** 以下配置均为全局性通配设置
         * MCToast已经提供了一套默认值，如果与您的要求不相符，您完全可以根据以下方法通配它。
         * 如果某一个toast需要单独设置，可以在调用MCToast的类方法里面单独设置参数值。
         */
        
        
        
        // 1. 配置Toast弹出过程中的交互类型（MCToastRespond：禁止交互，导航栏下禁止交互，允许交互）
        MCToastConfig.shared.respond = .allow
        
        
        // 2. 配置Toast核心区域（黑色区域）
        // 颜色
        MCToastConfig.shared.background.color = UIColor.black
        // 大小
        MCToastConfig.shared.icon.toastWidth = 120
        
        
        // 3. 配置状态Toast（成功，失败，警告等状态）的Icon
        MCToastConfig.shared.icon.imageSize = CGSize(width: 50, height: 50)
        MCToastConfig.shared.icon.successImage = UIImage(named: "你成功状态的Icon")
        MCToastConfig.shared.icon.failureImage = UIImage(named: "你失败状态的Icon")
        MCToastConfig.shared.icon.warningImage = UIImage(named: "你警告状态的Icon")

        
        // 4. 配置文字
        MCToastConfig.shared.text.font = UIFont.systemFont(ofSize: 15)
        MCToastConfig.shared.text.textColor = UIColor.white
//        MCToastConfig.shared.text.landscapeTextOffset = (UIScreen.main.bounds.size.height / 2 - 120 - 150)
        
        
        // 5. 配置间距
        // 外边距（toast距离屏幕边的最小边距
//        MCToastConfig.shared.spacing.margin = 55
        // 内边距（toast和其中的内容的最小边距）
//        MCToastConfig.shared.spacing.padding = 15
        
        
        // 6. 设置自动隐藏的时长
        MCToastConfig.shared.duration = 2.5
    }
}


extension UIView {
    func addCrosshairLines() {
        let midX = bounds.midX
        let midY = bounds.midY
        
        // 横线
        let horizontal = UIView()
        horizontal.backgroundColor = .red
        horizontal.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontal)
        NSLayoutConstraint.activate([
            horizontal.centerYAnchor.constraint(equalTo: centerYAnchor),
            horizontal.leadingAnchor.constraint(equalTo: leadingAnchor),
            horizontal.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontal.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        // 竖线
        let vertical = UIView()
        vertical.backgroundColor = .red
        vertical.translatesAutoresizingMaskIntoConstraints = false
        addSubview(vertical)
        NSLayoutConstraint.activate([
            vertical.centerXAnchor.constraint(equalTo: centerXAnchor),
            vertical.topAnchor.constraint(equalTo: topAnchor),
            vertical.bottomAnchor.constraint(equalTo: bottomAnchor),
            vertical.widthAnchor.constraint(equalToConstant: 1)
        ])
        
        // 实心圆圈
        let circleDiameter: CGFloat = 12
        let circle = UIView()
        circle.backgroundColor = .red
        circle.layer.cornerRadius = circleDiameter / 2
        circle.translatesAutoresizingMaskIntoConstraints = false
        addSubview(circle)
        NSLayoutConstraint.activate([
            circle.centerXAnchor.constraint(equalTo: centerXAnchor),
            circle.centerYAnchor.constraint(equalTo: centerYAnchor),
            circle.widthAnchor.constraint(equalToConstant: circleDiameter),
            circle.heightAnchor.constraint(equalToConstant: circleDiameter)
        ])
    }
}

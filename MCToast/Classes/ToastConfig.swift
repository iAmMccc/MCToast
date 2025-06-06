//
//  MCToastConfig.swift
//  MCComponentFunction_Example
//
//  Created by Mccc on 2019/7/8.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import UIKit




public struct MCToastConfig {
    public static let shared = MCToastConfig()
    
    /// 设置交互区域 默认导航栏下禁止交互
    public var respond = MCToast.RespondPolicy.allow
    
    /// 背景的设置
    public var background = Background()
    
    /// 状态Icon的设置
    public var icon = Icon()
    
    /// 文本的设置
    public var text = Text()
    
    
    /// 自动隐藏的时长
    public var duration: CGFloat = 1.5
}


extension MCToastConfig {
    public struct Background {
        /// toast 的背景颜色
        public var color: UIColor = UIColor.black.withAlphaComponent(0.9)
        public var colorAlpha: CGFloat = 0.8
    }
    
    public struct Icon {
        /// icon类型的toast的宽度，高度根据文字动态计算
        public var toastWidth: CGFloat = 160
        /// 内边距（toast和其中的内容的最小边距）
        public var padding: UIEdgeInsets = UIEdgeInsets(top: 20, left: 15, bottom: 20, right: 15)
        /// 圆角
        public var cornerRadius: CGFloat = 8
        /// 图片size
        public var imageSize: CGSize = CGSize.init(width: 50, height: 50)
        
        /// 自定义成功的icon
        public var successImage: UIImage?
        /// 自定义失败的icon
        public var failureImage: UIImage?
        /// 自定义警告的icon
        public var warningImage: UIImage?
        
        public var textColor: UIColor = UIColor.white
        public var font: UIFont = UIFont.systemFont(ofSize: 14)
    }
    
    public struct Text {
        public var textColor: UIColor = UIColor.white
        public var font: UIFont = UIFont.systemFont(ofSize: 14)
        /// 圆角
        public var cornerRadius: CGFloat = 4
        /// 内边距（toast和其中的内容的最小边距）
        public var padding: UIEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        
        /// 文字的最大宽度 （最大宽度 + 内边距 = toast的宽度）
        public var maxWidth: CGFloat = 224
        /// 文字的最小宽度 （最小宽度 + 内边距 = toast的宽度）
        public var minWidth: CGFloat = 88
        
        /// 横竖屏配置
        public var landscapeTextOffset: CGFloat = 60
        public var portraitTextOffset: CGFloat = 118
        public var avoidKeyboardOffsetY: CGFloat = 40
        /// toast底部距离屏幕底部距离
        public var offset: CGFloat {
            let isLandscape = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation.isLandscape ?? false
            if isLandscape {
                return landscapeTextOffset
            } else {
                return portraitTextOffset
            }
        }
    }
}

//
//  ToastContentView.swift
//  MCToast
//
//  Created by qixin on 2025/6/6.
//

import Foundation


class ToastContentView: UIView {
    
    var bottomConstraint: NSLayoutConstraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func setupConstraints(style: MCToast.Style) {
//        
//        guard let superview = superview else {
//            fatalError("need superview")
//        }
//        
//        switch style {
//        case .text:
////            // 让mainView大小刚好包裹label内容
////            // 先给个宽最大限制，防止太宽
////            let maxWidth = MCToastConfig.shared.text.maxWidth + MCToastConfig.shared.text.padding.horizontal
////            
////            NSLayoutConstraint.activate([
////                centerXAnchor.constraint(equalTo: superview.centerXAnchor),
////                // 限制最大宽度
////                widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth)
////            ])
////            
////            var bottomConstraint: NSLayoutConstraint
////            if KeyboardManager.shared.currentVisibleKeyboardHeight > 0 {
////                let bottomOffset = -KeyboardManager.shared.currentVisibleKeyboardHeight - MCToastConfig.shared.text.avoidKeyboardOffsetY
////                bottomConstraint = bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottomOffset)
////            } else {
////                let bottomOffset = -offset
////                bottomConstraint = bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottomOffset)
////            }
////            bottomConstraint.isActive = true
////            self.bottomConstraint = bottomConstraint
//            break
//        case .icon:
//            NSLayoutConstraint.activate([
//                centerXAnchor.constraint(equalTo: superview.centerXAnchor),
//                centerYAnchor.constraint(equalTo: superview.centerYAnchor),
//                widthAnchor.constraint(equalToConstant: MCToastConfig.shared.icon.toastWidth)
//            ])
//        case .loading:
//            // 主视图居中 + 宽度约束
//            NSLayoutConstraint.activate([
//                centerXAnchor.constraint(equalTo: superview.centerXAnchor),
//                centerYAnchor.constraint(equalTo: superview.centerYAnchor),
//                widthAnchor.constraint(equalToConstant: MCToastConfig.shared.icon.toastWidth)
//            ])
//
//        case .custom:
//            break
//        case .statusBar:
//            break
//        }
//    }
}

//
//  ToastWindow.swift
//  MCToast
//
//  Created by qixin on 2025/6/5.
//

import Foundation


class ToastWindow: UIWindow {
    var response: MCToast.MCToastRespond = .allow
    var navBarFrame: CGRect = .zero
    
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
       
        let topInset = safeAreaInsets.top
        navBarFrame = CGRect(x: 0, y: 0, width: bounds.width, height: topInset + 44)
        
        switch response {
        case .forbid:
            return true
        case .allow:
            return false
        case .allowNav:
            if navBarFrame.contains(point) {
                return false
            }
            return true
        }
    }
}

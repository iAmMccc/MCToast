//
//  ToastContentView.swift
//  MCToast
//
//  Created by qixin on 2025/6/6.
//

import Foundation


class ToastContentView: UIView {
    
    var bottomConstraint: NSLayoutConstraint?
    var position: MCToast.Position = .center

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

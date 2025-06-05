//
//  TestOneViewController.swift
//  MCToast_Example
//
//  Created by qixin on 2025/6/5.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import MCToast

class TestOneViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        DispatchQueue.main.async {
            let toastWindow = MCToast.mc_text("加载中", duration: 10)
            
            print("windows = \(MCToast.windows)")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                print("windows = \(MCToast.windows)")
                print("window.isHidden = \(toastWindow?.isHidden)")
                print("toastView superview = \(toastWindow?.superview)")
            }
        }
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            MCToast.mc_text("加载中", duration: 10)
//        }
        
//        let toastWindow = MCToast.mc_text("加载中", duration: 10)
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            print("window.isHidden = \(toastWindow?.isHidden)")
//            print("toastView superview = \(toastWindow?.superview)")
//        }
        
//        MCToast.mc_text("加载中", duration: 10)

    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MCToast.mc_remove()
    }
}



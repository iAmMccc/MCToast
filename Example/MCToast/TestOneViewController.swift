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
        
        
        MCToast.plainText("加载成功")
            .duration(2)
            .respond(.allow)
            .showHandler {
                print("开始显示了")
            }
            .dismissHandler {
                print("Toast 隐藏了")
            }

    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MCToast.remove()
    }
}



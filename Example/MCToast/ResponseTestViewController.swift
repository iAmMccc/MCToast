//
//  LoadingViewController.swift
//  MCToast_Example
//
//  Created by Mccc on 2019/11/25.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import MCToast

class ResponseTestViewController: UIViewController {

    var response: MCToast.MCToastRespond = .allow
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white                
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MCToast.mc_text("加载中", duration: 4, respond: response)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("\(#file) 点了")
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MCToast.mc_remove()
    }
}




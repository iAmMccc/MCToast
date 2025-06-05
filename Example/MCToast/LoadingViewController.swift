//
//  LoadingViewController.swift
//  MCToast_Example
//
//  Created by Mccc on 2019/11/25.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import MCToast

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
                
//        MCToast.mc_loading(text: "loading")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        MCToast.mc_text("加载中", duration: 0, respond: .forbid)

//        MCToast.mc_success("成功了", duration: 0, respond: .allowNav)
        
//        MCToast.mc_loading(text: "", duration: 0, respond: .allow)
        
        MCToast.mc_statusBar("更新的信息", duration: 4, backgroundColor: UIColor.red)
        
        
//        let customView = UIView()
//        customView.frame = CGRect(x: 0, y: 0, width: 200, height: 300)
//        let label = UILabel()
//        label.text = "自定义的内容"
//        label.sizeToFit()
//        label.center = customView.center
//        label.backgroundColor = UIColor.red
//        customView.addSubview(label)
//        MCToast.showCustomView(customView, duration: 4, respond: .allow)
        
        print("点击了")
    }
    

//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        MCToast.mc_remove()
//    }
}




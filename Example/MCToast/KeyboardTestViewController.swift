//
//  KeyboardTestViewController.swift
//  MCToast_Example
//
//  Created by qixin on 2025/6/5.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import MCToast

class KeyboardTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
                
//        MCToast.mc_loading(text: "loading")
        
        view.addSubview(textField)
        
        view.addSubview(showButton)
        view.addSubview(hiddenKeyboardButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        textField.becomeFirstResponder()
    }
    
    lazy var textField: UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor.red
        tf.frame = CGRect(x: 0, y: 100, width: 200, height: 50)
        return tf
    }()
    
    lazy var showButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.green
        btn.frame = CGRect(x: 10, y: 200, width: 60, height: 40)
        btn.addTarget(self, action: #selector(showEvent), for: .touchUpInside)
        return btn
    }()
    
    
    lazy var hiddenKeyboardButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.backgroundColor = UIColor.green
        btn.frame = CGRect(x: 120, y: 200, width: 60, height: 40)
        btn.addTarget(self, action: #selector(hiddenEvent), for: .touchUpInside)
        return btn
    }()
    
    @objc func showEvent() {
        MCToast.mc_text("加载中", duration: 16, respond: .allow)

    }
    
    @objc func hiddenEvent() {
        textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

//        MCToast.mc_success("成功了", duration: 0, respond: .allowNav)
        
//        MCToast.mc_loading(text: "", duration: 0, respond: .allow)
        
//        MCToast.mc_statusBar("更新的信息", duration: 4, backgroundColor: UIColor.red)
        
        
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
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MCToast.mc_remove()
    }
}




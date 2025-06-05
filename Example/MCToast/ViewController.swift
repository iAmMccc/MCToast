//
//  ViewController.swift
//  MCToast
//
//  Created by 562863544@qq.com on 11/25/2019.
//  Copyright (c) 2019 562863544@qq.com. All rights reserved.
//

import UIKit
import MCToast
import SnapKit


class ViewController: UIViewController {

    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 最好写在appdelegate中
        configToast()

        baseSetting()

        initUI()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        MCToast.mc_remove()
    }
    
    // MARK: - Setter & Getter
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    lazy var dataArray = [
        
        [
            "文本 - 短文本",
            "文本 - 长文本",
            "文本 - 设置展示时长",
            "文本 - 展示期间页面禁止响应",
            "文本 - 展示期间导航栏以下禁止响应",
            "文本 - 展示期间允许响应",
            "文本 - 设置偏移量（Y轴展示位置）",
        ],
        
        [
            "icon - 成功",
            "icon - 失败",
            "icon - 警告",
            "icon - 长文本信息",
            "icon - 自定义",
            "icon - 展示期间页面禁止响应",
            "icon - 展示期间导航栏以下禁止响应",
            "icon - 展示期间允许响应",
        ],
        
        
        [
            "loading - 固定时间自动隐藏",
            "loading - 手动控制隐藏",
            "loading - 展示期间页面禁止响应",
            "loading - 展示期间导航栏以下禁止响应",
            "loading - 展示期间允许响应",
        ],
        
        [
            "状态栏 - 显示在状态栏",
        ],
        
        [
            "组合使用 - 旋转toast",
            "组合使用 - 多个状态切换的处理",
            "组合使用 - 动态改变文字内容"
        ],
        
        [
            "自定义"
        ]
    ]
}

extension ViewController {
    func configToast() {
        /// 是否需要配置UI
        //        MCToastConfig.shared.background.size = CGSize.init(width: 200, height: 200)
        //        MCToastConfig.shared.icon.size = CGSize.init(width: 150, height: 150)
        //        MCToastConfig.shared.icon.successImage = UIImage.init(named: "code")
        
//        MCToastConfig.shared.text.offset = (UIScreen.main.bounds.size.height / 2 - 120 - 150)
//        MCToastConfig.shared.respond = MCToast.MCToastRespond.noRespond
    }
}

//MARK: UI的处理,通知的接收
extension ViewController {
    
    func baseSetting() {
        navigationItem.title = "Toast提示"
    }
    
    func initUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
}

//MARK: 代理方法

extension ViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let arr = dataArray[section]
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "文本"
        case 1:
            return "icon"
        case 2:
            return "loading"
        case 3:
            return "状态栏"
        case 4:
            return "组合使用"
        case 5:
            return "自定义使用"
        default:
            return ""
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        let cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: identifier)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundColor = UIColor.white
        
        let arr = dataArray[indexPath.section]
        cell.textLabel?.text = arr[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let vc = KeyboardTestViewController()

        let vc = LoadingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
//        switch indexPath.section {
//        case 0:
//            showToastOnSection0(with: indexPath.row)
//        case 1:
//            showToastOnSection1(with: indexPath.row)
//        case 2:
//            showToastOnSection2(with: indexPath.row)
//        case 3:
//            showToastOnSection3(with: indexPath.row)
//        case 4:
//            showToastOnSection4(with: indexPath.row)
//        case 5:
//            
//            showToastOnSection5(with: indexPath.row)
//        default:
//            break
//        }
    }
}


extension ViewController {
    func showToastOnSection0(with row: Int) {
        switch row {
        case 0:
            MCToast.mc_text("提示文案", offset: 118)
        case 1:
            MCToast.mc_text("这是一个很长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长长的纯文本的展示", duration: 10)
        case 2:
            MCToast.mc_text("提示文案", duration: 4)
        case 3:
            MCToast.mc_text("提示文案", respond: .forbid)
        case 4:
            MCToast.mc_text("提示文案", respond: .allowNav)
        case 5:
            MCToast.mc_text("提示文案", respond: .allow)
        case 6:
            MCToast.mc_text("居中显示", offset: UIScreen.main.bounds.size.height / 2)
        default:
            break
        }
    }
}

extension ViewController {
    func showToastOnSection1(with row: Int) {
        switch row {
        case 0:
            MCToast.mc_success("成功")
        case 1:
            MCToast.mc_failure("失败")
        case 2:
            MCToast.mc_warning("警告")
        case 3:
            MCToast.mc_failure("这是一个很长长长长长长长长长长长长长长长长长长长长长长长长失败状态", duration: 2)
        case 4:
            MCToast.mc_codeSuccess()
        case 5:
            MCToast.mc_success("成功", respond: .forbid)
        case 6:
            MCToast.mc_success("成功", respond: .allowNav)
        case 7:
            MCToast.mc_success("成功", respond: .allow)
        default:
            break
        }
    }
}


extension ViewController {
    func showToastOnSection2(with row: Int) {
        switch row {
        case 0:
            MCToast.mc_loading(duration: 2)
        case 1:
            MCToast.mc_loading(text: "")
        case 2:
            MCToast.mc_loading(duration: 2, respond: .forbid)
        case 3:
            MCToast.mc_loading(duration: 2, respond: .allowNav)
        case 4:
            MCToast.mc_loading(duration: 2, respond: .allow)
        default:
            break
        }
    }
}


extension ViewController {
    func showToastOnSection3(with row: Int) {
        switch row {
        case 0:
            self.mc_statusBar("有内容更新啦，赶紧看看吧")
        default:
            break
        }
    }
}

extension ViewController {
    func showToastOnSection4(with row: Int) {
        switch row {
        case 0:
            if let customWindow = MCToast.mc_success("旋转toast提示方向") {
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(0.01) // 跟随视图动画时间
                let rotate = CGFloat.pi / 2
                customWindow.transform = customWindow.transform.rotated(by: rotate)
                UIView.commitAnimations()
            }
        case 1:
            MCToast.mc_text("开始上传", callback: {
                MCToast.mc_loading(text: "上传中...", duration: 5, callback: {
                    MCToast.mc_success("上传完成")
                })
            })
        case 2:
            let image = UIImage.init(named: "codesend")
            let window = MCToast.showStatus(text: "倒计时开始", iconImage: image, duration: 5, respond: .allow)
            

            guard let tempWindow = window  else { return }
            
            var contentView: UIView?
            
            var textLabel: UILabel?
            var imageView: UIImageView?

            for subview in tempWindow.subviews {
                
                if subview.isKind(of: UIView.self) {
                    contentView = subview
                    break
                }
            }
            
            for subview in contentView?.subviews ?? [] {
                if subview.isKind(of: UILabel.self) {
                    textLabel = subview as? UILabel
                }
                
                if subview.isKind(of: UIImageView.self) {
                    imageView = subview as? UIImageView
                }
            }
            
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                UIView.animate(withDuration: 0.2) {
                    textLabel?.text = "倒计时 3"
                    imageView?.image = UIImage.init(named: "toast_success")
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                UIView.animate(withDuration: 0.2) {
                    textLabel?.text = "倒计时 2"
                    imageView?.image = UIImage.init(named: "toast_failure")
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) {
                UIView.animate(withDuration: 0.2) {
                    textLabel?.text = "倒计时 1"
                    imageView?.image = UIImage.init(named: "toast_warning")
                }
            }
        default:
            break
        }
    }
}

extension ViewController {
    func showToastOnSection5(with row: Int) {
        let customView = UIView()
        customView.frame = CGRect(x: 0, y: 0, width: 200, height: 300)
        let label = UILabel()
        label.text = "自定义的内容"
        label.sizeToFit()
        label.center = customView.center
        label.backgroundColor = UIColor.red
        customView.addSubview(label)
        MCToast.showCustomView(customView, duration: 2, respond: .allow)
    }
}


extension MCToast {
    
    /// 发送验证码成功
    public static func mc_codeSuccess() {
        let image = UIImage.init(named: "codesend")
        MCToast.showStatus(text: "发送验证码成功", iconImage: image, duration: 2, respond: .allow)
    }
}

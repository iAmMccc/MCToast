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
    

    
    // MARK: - Setter & Getter
    lazy var tableView: UITableView = {
        let tableView = UITableView.init(frame: CGRect.zero, style: UITableView.Style.plain)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()

    lazy var dataSource: [(title: String, rows: [String])] = [
        (
            title: "测试",
            rows: [
                "测试 - 1",
                "测试 - 2",
                "测试 - 3"
            ]
        ),
        (
            title: "文本",
            rows: [
                "文本 - 短文本",
                "文本 - 长文本",
                "文本 - 设置展示时长",
                "文本 - 展示期间页面禁止响应",
                "文本 - 展示期间导航栏以下禁止响应",
                "文本 - 展示期间允许响应",
                "文本 - 设置偏移量（Y轴展示位置）"
            ]
        ),
        (
            title: "icon",
            rows: [
                "icon - 成功",
                "icon - 失败",
                "icon - 警告",
                "icon - 长文本信息",
                "icon - 自定义",
                "icon - 展示期间页面禁止响应",
                "icon - 展示期间导航栏以下禁止响应",
                "icon - 展示期间允许响应"
            ]
        ),
        (
            title: "loading",
            rows: [
                "loading - 固定时间自动隐藏",
                "loading - 手动控制隐藏",
                "loading - 展示期间页面禁止响应",
                "loading - 展示期间导航栏以下禁止响应",
                "loading - 展示期间允许响应"
            ]
        ),
        (
            title: "自定义",
            rows: [
                "自定义 - 自定义视图",
                "自定义 - 显示在状态栏"
            ]
        ),
        (
            title: "响应测试",
            rows: [
                "响应测试 - 完全响应",
                "响应测试 - 完全禁止",
                "响应测试 - 仅导航栏响应"
            ]
        ),
        (
            title: "组合使用",
            rows: [
                "组合使用 - 旋转toast",
                "组合使用 - 多个状态切换的处理",
                "组合使用 - 动态改变文字内容"
            ]
        ),
        (
            title: "其他",
            rows: [
                "其他 - 测试键盘遮挡",
            ]
        )
        
    ]

}

extension ViewController {
    func configToast() {
        /// 是否需要配置UI
        //        MCToastConfig.shared.background.size = CGSize.init(width: 200, height: 200)
        //        MCToastConfig.shared.icon.size = CGSize.init(width: 150, height: 150)
        //        MCToastConfig.shared.icon.successImage = UIImage.init(named: "code")
        
//        MCToastConfig.shared.text.offset = (UIScreen.main.bounds.size.height / 2 - 120 - 150)
//        MCToastConfig.shared.respond = RespondPolicy.noRespond
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
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].rows.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].title

    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "cell"
        let cell = UITableViewCell.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: identifier)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.backgroundColor = UIColor.white
        
        cell.textLabel?.text = dataSource[indexPath.section].rows[indexPath.row]

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            showToastOnSection0(with: indexPath.row)
        case 1:
            showToastOnSection1(with: indexPath.row)
        case 2:
            showToastOnSection2(with: indexPath.row)
        case 3:
            showToastOnSection3(with: indexPath.row)
        case 4:
            showToastOnSection4(with: indexPath.row)
        case 5:
            showToastOnSection5(with: indexPath.row)
        case 6:
            showToastOnSection6(with: indexPath.row)
        case 7:
            showToastOnSection7(with: indexPath.row)
        default:
            break
        }
    }
}

extension ViewController {
    func showToastOnSection0(with row: Int) {
        switch row {
        case 0:
            let vc = TestOneViewController()
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            break
        default:
            break
        }
    }
}


extension ViewController {
    func showToastOnSection1(with row: Int) {
        switch row {
        case 0:
            MCToast.plainText("提示文案")
        case 1:
            MCToast.plainText("这是一个很长长长长长长长长长长长长长长长长长长长长长长长长长长长的纯文本的展示")
        case 2:
            MCToast.plainText("提示文案，设置时长4秒").duration(4)
        case 3:
            MCToast.plainText("提示文案，交互方式：完全禁止").respond(.forbid)
        case 4:
            MCToast.plainText("提示文案，交互方式：仅导航栏").respond(.allowNav)
        case 5:
            MCToast.plainText("提示文案，交互方式：完全允许").respond(.allow)
        case 6:
            MCToast.plainText("这是一个很长长长长长长长长长长长长长长长长长长长长长长长长长长长的纯文本的展示")
                .position(.top(offset: 100))
        default:
            break
        }
    }
}

extension ViewController {
    func showToastOnSection2(with row: Int) {
        switch row {
        case 0:
            MCToast.success("成功")
        case 1:
            MCToast.failure("失败")
        case 2:
            MCToast.warning("警告")
        case 3:
            MCToast.failure("这是一个很长长长长长长长长长长长长长长长长长长长长长长长长失败状态", duration: 2)
        case 4:
            MCToast.codeSuccess()
        case 5:
            MCToast.success("成功", respond: .forbid)
        case 6:
            MCToast.success("成功", respond: .allowNav)
        case 7:
            MCToast.success("成功", respond: .allow)
        default:
            break
        }
    }
}


extension ViewController {
    func showToastOnSection3(with row: Int) {
        switch row {
        case 0:
            MCToast.loading(duration: 2)
        case 1:
            MCToast.loading(text: "")
        case 2:
            MCToast.loading(duration: 2, respond: .forbid)
        case 3:
            MCToast.loading(duration: 2, respond: .allowNav)
        case 4:
            MCToast.loading(duration: 2, respond: .allow)
        default:
            break
        }
    }
}


extension ViewController {
    func showToastOnSection4(with row: Int) {
        switch row {
        case 0:
            let customView = UIView()
            customView.frame = CGRect(x: 0, y: 0, width: 200, height: 300)
            let label = UILabel()
            label.text = "自定义的内容"
            label.sizeToFit()
            label.center = customView.center
            label.backgroundColor = UIColor.red
            customView.addSubview(label)
            MCToast.showCustomView(customView, duration: 2, respond: .allow)
        case 1:
            
            let customView = UIView()
            customView.backgroundColor = UIColor.green
            customView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 88)
            
            let label = UILabel()
            label.text = "自定义的内容"
            label.textAlignment = .center
            label.sizeToFit()
            label.center = customView.center
            label.backgroundColor = UIColor.red
            customView.addSubview(label)
            
            MCToast.statusBar(view: customView)
        default:
            break
        }
    }
}

extension ViewController {
    func showToastOnSection5(with row: Int) {
        let vc = ResponseTestViewController()
        switch row {
        case 0:
            vc.response = .allow
        case 1:
            vc.response = .forbid
        case 2:
            vc.response = .allowNav
        default:
            break
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController {
    func showToastOnSection6(with row: Int) {
        switch row {
        case 0:
            if let customWindow = MCToast.success("旋转toast提示方向") {
                
                UIView.animate(withDuration: 0.01,
                               delay: 0,
                               options: [.curveLinear],
                               animations: {
                                   customWindow.transform = customWindow.transform.rotated(by: .pi / 2)
                               },
                               completion: nil)
            }
        case 1:
            MCToast.text("开始上传", dismissHandler: {
                MCToast.loading(text: "上传中...", duration: 5, dismissHandler: {
                    MCToast.success("上传完成")
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
    func showToastOnSection7(with row: Int) {
        let vc = KeyboardTestViewController()
//        switch row {
//        case 0:
//            vc.response = .allow
//        case 1:
//            vc.response = .forbid
//        case 2:
//            vc.response = .allowNav
//        default:
//            break
//        }
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension MCToast {
    
    /// 发送验证码成功
    public static func codeSuccess() {
        let image = UIImage.init(named: "codesend")
        MCToast.showStatus(text: "发送验证码成功", iconImage: image, duration: 2, respond: .allow)
    }
}

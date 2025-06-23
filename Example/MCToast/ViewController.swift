//
//  ViewController.swift
//  MCToast
//
//  Created by Mccc on 11/25/2019.
//  Copyright (c) 2019 Mccc. All rights reserved.
//

import UIKit
import MCToast
import SnapKit
import Lottie

class ViewController: UIViewController {

    // life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        

        baseSetting()

        initUI()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
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
            ]
        ),
        (
            title: "文本",
            rows: [
                "文本 - 短文本",
                "文本 - 长文本",
                "文本 - 设置展示时长",
                "文本 - 设置偏移量（Y轴展示位置）",
                "文本 - 设置响应策略",
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
                "icon - 设置响应策略",
            ]
        ),
        (
            title: "loading",
            rows: [
                "loading - 没有文字",
                "loading - 有文字",
                "loading - 自定隐藏",
                "loading - 设置响应策略",
            ]
        ),
        (
            title: "自定义",
            rows: [
                "自定义 - 自定义视图",
                "自定义 - 显示在状态栏",
                "自定义 - lottie动画"
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
            MCToast.plainText("这是一个很长长长长长长长长长长长长长长长长长长长长长长长长长长长的纯文本的展示")
                .position(.top(offset: 100))
        case 4:
            MCToast.plainText("提示文案，交互方式：完全禁止").respond(.forbid)
        default:
            break
        }
    }
}

extension ViewController {
    func showToastOnSection2(with row: Int) {
        switch row {
        case 0:
            MCToast.iconText("成功", icon: .success)
        case 1:
            MCToast.iconText("失败", icon: .failure)
        case 2:
            MCToast.iconText("警告", icon: .warning)
        case 3:
            MCToast.iconText("这是一个很长长长长长长长长长长长长长长长长长长长长长长长长成功状态", icon: .success)
        case 4:
            MCToast.iconText("自定义", icon: .custom(UIImage(named: "codesend")))
        case 5:
            MCToast.iconText("成功", icon: .success)
                .respond(.forbid)
        default:
            break
        }
    }
}


extension ViewController {
    func showToastOnSection3(with row: Int) {
        switch row {
        case 0:
            MCToast.loadingText()
                .duration(2)
        case 1:
            MCToast.loadingText("加载中...")
                .duration(3)
        case 2:
            MCToast.loadingText("加载中...")
                .duration(4)
        case 3:
            MCToast.loadingText("加载中...")
                .respond(.allow)
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
            customView.backgroundColor = UIColor.black
            let label = UILabel()
            label.text = "自定义的内容"
            label.sizeToFit()
            label.center = customView.center
            label.backgroundColor = UIColor.red
            customView.addSubview(label)
            
            MCToast.custom(customView)
                .duration(2.5)
                .respond(.allow)
                .showHandler({
                    print("显示了")
                })
                .dismissHandler {
                    print("消失了")
                }
            
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
            
            MCToast.statusBarView(customView)
            
        case 2:
            // 加载 JSON 动画
            let animation = LottieAnimation.named("waiting")
            let animView = LottieAnimationView(animation: animation)
            animView.backgroundColor = UIColor.black
            animView.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
            animView.contentMode = .scaleAspectFit
            animView.loopMode = .loop
            animView.play()
            MCToast.custom(animView)
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
            
            
            let builder = MCToast.iconText("旋转方向", icon: .success, autoShow: false)
            builder.showHandler {
                UIView.animate(withDuration: 0.01,
                               delay: 0,
                               options: [.curveLinear],
                               animations: {
                    builder.window?.transform = builder.window!.transform.rotated(by: .pi / 2)
                },
                               completion: nil)
            }
            builder.show()
            
            
        case 1:
            
            MCToast.plainText("开始上传").dismissHandler {
                MCToast.loadingText("上传中").dismissHandler {
                    MCToast.iconText("上传成功", icon: .success)
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



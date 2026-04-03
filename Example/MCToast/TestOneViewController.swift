//
//  TestOneViewController.swift
//  MCToast_Example
//
//  Created by qixin on 2025/6/5.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import MCToast
import UIKit


/// 演示 autoShow 竞态条件 Bug
///
/// 场景：数据加载非常快（如使用本地缓存/JSON），时序如下：
///   1. showLoading() -> DispatchQueue.main.async 将 show 任务排入队列（Pending）
///   2. 数据立即返回 -> 调用 MCToast.remove()（此时 toast 还没显示，remove 清空了空状态）
///   3. 主队列执行 async 任务 -> Toast 被显示出来
///   4. 结果：Loading 永远卡在界面上，因为后续没有 remove 调用了
class TestOneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = "autoShow 竞态 Bug 演示"

        setupButtons()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MCToast.remove()
    }

    private func setupButtons() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
        ])

        // 按钮1: 复现 Bug（autoShow: true）
        let bugButton = makeButton(title: "复现 Bug（autoShow: true）", color: .systemRed)
        bugButton.addTarget(self, action: #selector(reproduceBug), for: .touchUpInside)
        stackView.addArrangedSubview(bugButton)

        // 按钮2: 临时方案（autoShow: false + show）
        let workaroundButton = makeButton(title: "临时方案（autoShow: false + show）", color: .systemOrange)
        workaroundButton.addTarget(self, action: #selector(showWorkaround), for: .touchUpInside)
        stackView.addArrangedSubview(workaroundButton)

        // 按钮3: 手动 remove
        let removeButton = makeButton(title: "手动 Remove Toast", color: .systemBlue)
        removeButton.addTarget(self, action: #selector(manualRemove), for: .touchUpInside)
        stackView.addArrangedSubview(removeButton)

        // 说明
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.text = """
        点击「复现 Bug」后，Loading 会卡住无法消失。
        因为 remove() 在 show() 之前执行了。

        点击「临时方案」则正常，因为 show() 是同步执行的。

        点击「手动 Remove」可清除卡住的 Toast。
        """
        stackView.addArrangedSubview(label)
    }

    private func makeButton(title: String, color: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = color
        button.layer.cornerRadius = 8
        button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 20)
        return button
    }

    // MARK: - 复现 Bug

    /// 模拟：展示 loading -> 数据秒回 -> remove
    /// 结果：loading 卡在屏幕上无法消失
    @objc private func reproduceBug() {
        print("--- 复现 Bug 开始 ---")

        // 1. 展示 loading（autoShow: true，内部用 DispatchQueue.main.async 延迟显示）
        MCToast.loadingText("加载中...")
            .duration(0) // duration=0 表示不自动隐藏

        print("1. loadingText 已调用（但 show 还在 async 队列中）")

        // 2. 模拟数据秒回（同步返回，比如本地 JSON 缓存）
        let data = simulateFastDataLoad()
        print("2. 数据已返回: \(data.count) 条")

        // 3. 数据返回后立即 remove
        MCToast.remove()
        print("3. MCToast.remove() 已调用（但此时 toast 还没显示）")

        print("--- 接下来 async 队列中的 show 将执行，Loading 会卡住 ---")
    }

    // MARK: - 临时方案（用户在 issue 中提到的）

    /// 使用 autoShow: false + 手动 show()，show 是同步的，不存在竞态
    @objc private func showWorkaround() {
        print("--- 临时方案开始 ---")

        // 1. 展示 loading（autoShow: false，需手动 show）
        MCToast.loadingText("加载中...", autoShow: false)
            .duration(0)
            .show() // 同步执行，立即显示

        print("1. loading 已同步显示")

        // 2. 模拟数据秒回
        let data = simulateFastDataLoad()
        print("2. 数据已返回: \(data.count) 条")

        // 3. remove 可以正确移除
        MCToast.remove()
        print("3. MCToast.remove() 已调用 -> 正常移除 ✅")
    }

    // MARK: - 手动移除

    @objc private func manualRemove() {
        MCToast.remove()
        print("手动 remove 完成")
    }

    // MARK: - 模拟极速数据加载

    /// 模拟从本地 JSON 加载数据，同步返回
    private func simulateFastDataLoad() -> [[String: Any]] {
        return [
            ["id": 1, "name": "Item 1"],
            ["id": 2, "name": "Item 2"],
            ["id": 3, "name": "Item 3"],
        ]
    }
}

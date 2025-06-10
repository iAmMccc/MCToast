//
//  KeyboardTestViewController.swift
//  MCToast_Example
//
//  Created by qixin on 2025/6/5.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import MCToast

import UIKit

class KeyboardTestViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGroupedBackground
        
        setupUI()
    }

    private func setupUI() {
        view.addSubview(textField)
        view.addSubview(buttonStack)

        // Auto Layout for textField
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            textField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            textField.widthAnchor.constraint(equalToConstant: 250),
            textField.heightAnchor.constraint(equalToConstant: 50)
        ])

        // Auto Layout for buttonStack
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 30),
            buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: - UI Components

    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "点击弹出键盘"
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .white
        tf.clearButtonMode = .whileEditing
        tf.layer.shadowColor = UIColor.black.withAlphaComponent(0.1).cgColor
        tf.layer.shadowOpacity = 0.3
        tf.layer.shadowRadius = 4
        tf.layer.shadowOffset = CGSize(width: 0, height: 2)
        return tf
    }()

    private lazy var showButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("展示 Toast", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.layer.cornerRadius = 8
        btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        btn.addTarget(self, action: #selector(showEvent), for: .touchUpInside)
        return btn
    }()

    private lazy var hiddenKeyboardButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("隐藏键盘", for: .normal)
        btn.backgroundColor = .systemGray
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        btn.layer.cornerRadius = 8
        btn.contentEdgeInsets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        btn.addTarget(self, action: #selector(hiddenEvent), for: .touchUpInside)
        return btn
    }()

    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [showButton, hiddenKeyboardButton])
        stack.axis = .horizontal
        stack.spacing = 20
        stack.alignment = .center
        return stack
    }()

    // MARK: - Actions

    @objc private func showEvent() {
        MCToast.text("加载中", duration: 8, respond: .allow)
    }

    @objc private func hiddenEvent() {
        textField.resignFirstResponder()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MCToast.remove()
    }
}

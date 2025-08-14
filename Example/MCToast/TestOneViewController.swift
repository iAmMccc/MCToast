//
//  TestOneViewController.swift
//  MCToast_Example
//
//  Created by qixin on 2025/6/5.
//  Copyright © 2025 CocoaPods. All rights reserved.
//

import Foundation
import MCToast

import Photos


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
//        MCToast.remove()
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let image = UIImage(named: "codesend") {
            if #available(iOS 14, *) {
                PhotoSaver.saveImageToAlbum(image) { saved, error in
                    if saved {
                        MCToast.plainText("加载成功")
                            .duration(2)
                            .respond(.allow)
                            .showHandler {
                                print("开始显示了")
                            }
                            .dismissHandler {
                                print("Toast 隐藏了")
                            }
                    } else {
                        MCToast.plainText("保存失败")
                            .duration(2)
                            .respond(.allow)
                            .show()
                    }
                }
            } else {
                // iOS 13 及以下
                PHPhotoLibrary.requestAuthorization { status in
                    if status == .authorized {
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        DispatchQueue.main.async {
                            MCToast.plainText("加载成功")
                                .duration(2)
                                .respond(.allow)
                                .show()
                        }
                    } else {
                        DispatchQueue.main.async {
                            MCToast.plainText("无权限保存图片")
                                .duration(2)
                                .respond(.allow)
                                .show()
                        }
                    }
                }
            }
        }
        
    }
    
   
}


@available(iOS 14, *)
class PhotoSaver {
    
    /// 保存图片到相册
    static func saveImageToAlbum(_ image: UIImage, completion: ((Bool, Error?) -> Void)? = nil) {
        
        // 检查当前相册权限
        PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
            
            print(status.rawValue)
            DispatchQueue.main.async {
                switch status {
                case .authorized, .limited:
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    completion?(true, nil)
                case .denied, .restricted:
                    completion?(false, NSError(domain: "PhotoSaver", code: 1, userInfo: [NSLocalizedDescriptionKey: "无相册写入权限"]))
                case .notDetermined:
                    // 理论上不会走到这里，因为 requestAuthorization 已经请求了
                    completion?(false, NSError(domain: "PhotoSaver", code: 2, userInfo: [NSLocalizedDescriptionKey: "权限未确定"]))
                @unknown default:
                    completion?(false, NSError(domain: "PhotoSaver", code: 3, userInfo: [NSLocalizedDescriptionKey: "未知权限状态"]))
                }
            }
        }
    }
}

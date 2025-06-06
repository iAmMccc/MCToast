

## 为什么不能在viewDidLoad中显示？ 




## 页面返回时候如何全局设置隐藏？ 

```
override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)

    // 如果当前 loading 是这个页面触发的，可以隐藏
    MCToast.hideLoading()
}
```


```
extension UINavigationController: UINavigationControllerDelegate {
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    public func navigationController(_ navigationController: UINavigationController,
                                     didShow viewController: UIViewController,
                                     animated: Bool) {
        // 页面返回时自动移除 loading
        MCToast.hideLoading()
    }
}

```

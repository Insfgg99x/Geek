//
//  BaseViewController.swift
//  geek
//
//  Created by xgf on 2018/2/22.
//  Copyright © 2018年 xgf. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    func preferedBackButtonHidden() -> Bool {
        return false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        baseInit()
        setup()
        createUI()
        downloadData()
    }
    private func baseInit() {
        view.backgroundColor = rgb(245)
        //navigationController?.navigationBar.barStyle = . black
        if preferedBackButtonHidden() {
            return
        }
        let btn = UIButton.init(frame: .init(x: 0, y: 0, width: 44, height: 44))
        btn.setImage(UIImage.init(named: "back"), for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: #selector(backButtonClickAction), for: .touchUpInside)
        let backItem = UIBarButtonItem.init(customView: btn)
        navigationItem.leftBarButtonItem = backItem
    }
    @objc func backButtonClickAction() {
        navigationController?.popViewController(animated: true)
    }
    func setup() {
        
    }
    func createUI() {
        
    }
    func downloadData() {
        
    }
}


//
//  TabBarController.swift
//  geek
//
//  Created by xgf on 2018/2/22.
//  Copyright © 2018年 xgf. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        createControllers()
    }
    private func createControllers() {
        let home = HomeViewController()
        home.title = "主页"
        let homeNavi = UINavigationController.init(rootViewController: home)
        home.tabBarItem.image = UIImage.init(named: "tab_home")?.withRenderingMode(.alwaysOriginal)
        home.tabBarItem.selectedImage = UIImage.init(named: "tab_home_s")?.withRenderingMode(.alwaysOriginal)
        home.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:rgb(70)], for: .normal)
        home.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.black], for: .selected)
        
        let category = CategoryViewController()
        category.title = "分类"
        let categoryNavi = UINavigationController.init(rootViewController: category)
        category.tabBarItem.image = UIImage.init(named: "tab_category")?.withRenderingMode(.alwaysOriginal)
        category.tabBarItem.selectedImage = UIImage.init(named: "tab_category_s")?.withRenderingMode(.alwaysOriginal)
        category.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:rgb(70)], for: .normal)
        category.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.black], for: .selected)
        
        let setting = SettingViewController()
        setting.title = "我"
        let settingNavi = UINavigationController.init(rootViewController: setting)
        setting.tabBarItem.image = UIImage.init(named: "tab_me")?.withRenderingMode(.alwaysOriginal)
        setting.tabBarItem.selectedImage = UIImage.init(named: "tab_me_s")?.withRenderingMode(.alwaysOriginal)
        setting.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:rgb(70)], for: .normal)
        setting.tabBarItem.setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColor.black], for: .selected)
        
        viewControllers = [homeNavi,categoryNavi,settingNavi]
    }
}

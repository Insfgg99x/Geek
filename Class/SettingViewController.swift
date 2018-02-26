//
//  SettingViewController.swift
//  geek
//
//  Created by xgf on 2018/2/22.
//  Copyright © 2018年 xgf. All rights reserved.
//

import UIKit
import SDWebImage
import PKHUD
import StoreKit

class SettingViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, SKStoreProductViewControllerDelegate {
    private var dataArray = [["我的收藏"],["清除缓存"],["意见反馈","去评分"]]
    private var tbView = UITableView.init(frame: .zero, style: .grouped)
    private var headerView = UIView.init(frame: .init(x: 0, y: 0, width: screenwidth, height: 80))
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func preferedBackButtonHidden() -> Bool {
        return true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .automatic
            navigationController?.navigationBar.prefersLargeTitles = true
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
            navigationController?.navigationBar.prefersLargeTitles = false
        }
    }
    override func setup() {
        
    }
    override func createUI() {
        tbView.delegate = self
        tbView.dataSource = self
        if #available(iOS 9.0, *) {
            tbView.cellLayoutMarginsFollowReadableWidth = false
        }
        tbView.tableFooterView = UIView.init()
        tbView.tableHeaderView = headerView
        view.addSubview(tbView)
        tbView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
}
extension SettingViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray[section].count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cid")
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cid")
            cell?.selectionStyle = .none
            cell?.textLabel?.font = font16
            cell?.textLabel?.textColor = rgb(70)
        }
        cell?.textLabel?.text = dataArray[indexPath.section][indexPath.row]
        if indexPath.section != 1 {
            cell?.accessoryType = .disclosureIndicator
        } else {
            cell?.accessoryType = .none
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let favorite = FavoritesViewController()
            navigationController?.pushViewController(favorite, animated: true)
        } else if indexPath.section == 1 {
            SDImageCache.shared().clearDisk(onCompletion: {
                HUD.flash(HUDContentType.success)
            })
        } else {
            if indexPath.row == 0 {
                let path = "mailto:newbox0512@yahoo.com?subject=关于Geek的反馈".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                let url = URL.init(string: path!)
                guard url != nil else {
                    return
                }
                if UIApplication.shared.canOpenURL(url!) {
                    UIApplication.shared.openURL(url!)
                }
            } else {
                if #available(iOS 10.3, *) {
                    SKStoreReviewController.requestReview()
                } else {
                    let comment = SKStoreProductViewController.init()
                    comment.delegate = self
                    let p = [SKStoreProductParameterITunesItemIdentifier : itunesconnectId]
                    weak var wkself = self
                    weak var wkComment = comment
                    comment.loadProduct(withParameters: p, completionBlock: { (result, error) in
                        guard result else {
                            HUD.flash(HUDContentType.label(error?.localizedDescription))
                            return
                        }
                        wkself?.navigationController?.present(wkComment!, animated: true, completion: nil)
                    })
                }
            }
        }
    }
}
extension SettingViewController {
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}

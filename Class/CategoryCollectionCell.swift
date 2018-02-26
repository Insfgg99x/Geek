//
//  CategoryCollectionCell.swift
//  geek
//
//  Created by xia on 2018/2/23.
//  Copyright © 2018年 xgf. All rights reserved.
//

import UIKit
import MJRefresh
import PKHUD
import ObjectMapper

class CategoryCollectionCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    private var dataArray = [Feed]()
    private var tbView = UITableView.init(frame: .zero, style: .plain)
    var navi:UINavigationController?
    private var loading = false
    private var page = 1
    private var shouldReload = false
    var category: String? {
        willSet {
            if category != nil {
                if category == newValue {
                    shouldReload = false
                    return
                }
            }
            shouldReload = true
        } didSet {
            guard shouldReload else {
                return
            }
            tbView.mj_header.endRefreshing()
            tbView.mj_footer.endRefreshing()
            objc_sync_enter(dataArray)
            dataArray.removeAll()
            objc_sync_exit(dataArray)
            tbView.reloadData()
            page = 1
            loading = false
            donwloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        createUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setup() {
        backgroundColor = .white
    }
    private func createUI() {
        contentView.subviews.forEach{
            $0.removeFromSuperview()
        }
        tbView.delegate = self
        tbView.dataSource = self
        tbView.tableFooterView = UIView.init()
        contentView.addSubview(tbView)
        tbView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.contentView)
        }
        weak var wkself = self
        tbView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            wkself?.page = 1
            wkself?.donwloadData()
        })
        tbView.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
            wkself?.page += 1
            wkself?.donwloadData()
        })
    }
    private func donwloadData() {
        guard category != nil else {
            return
        }
        if loading {
            return
        }
        loading = true
        weak var wkself = self
        let url = String.init(format: url_category, category!, page).addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        Networking.shared.get(url: url!, success: { (info) in
            guard let results = info["results"] as? Array<Dictionary<String, Any>> else {
                wkself?.tbView.mj_header.endRefreshing()
                wkself?.tbView.mj_footer.endRefreshing()
                HUD.flash(.labeledError(title: nil, subtitle: "数据格式错误,请稍后重试~"))
                if wkself!.page > 1 {
                    wkself?.page -= 1
                }
                wkself?.loading = false
                return
            }
            var array = [Feed]()
            for dict in results {
                let feed = Mapper<Feed>.init().map(JSON: dict)
                guard feed != nil else {
                    continue
                }
                array.append(feed!)
            }
            objc_sync_enter(wkself!.dataArray)
            if wkself?.page == 1 {
                wkself?.dataArray.removeAll()
            }
            wkself?.dataArray.append(contentsOf: array)
            objc_sync_exit(wkself!.dataArray)
            wkself?.tbView.mj_header.endRefreshing()
            wkself?.tbView.mj_footer.endRefreshing()
            wkself?.tbView.reloadData()
            wkself?.loading = false
        }, failure: { (error) in
            wkself?.tbView.mj_header.endRefreshing()
            wkself?.tbView.mj_footer.endRefreshing()
            HUD.flash(.labeledError(title: nil, subtitle: error.localizedDescription))
            if wkself!.page > 1 {
                wkself?.page -= 1
            }
            wkself?.loading = false
        })
    }
}
extension CategoryCollectionCell {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "feed_cid") as? FeedCell
        if cell == nil {
            cell = FeedCell.init(style: .default, reuseIdentifier: "feed_cid")
        }
        var feed:Feed? = nil
        if dataArray.count > indexPath.row {
            feed = dataArray[indexPath.row]
        }
        if feed != nil {
            cell?.feed = feed
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var feed:Feed? = nil
        if dataArray.count > indexPath.row {
            feed = dataArray[indexPath.row]
        }
        guard feed != nil else {
            return
        }
        let detail = FeedDetailViewController()
        detail.feed = feed
        navi?.pushViewController(detail, animated: true)
    }
}

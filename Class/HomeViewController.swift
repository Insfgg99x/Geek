//
//  ViewController.swift
//  geek
//
//  Created by xgf on 2018/2/22.
//  Copyright © 2018年 xgf. All rights reserved.
//

import UIKit
import SnapKit
import PKHUD
import ObjectMapper
import MJRefresh
import SDWebImage

private var ArrayCategoryKey = "ArrayCategoryKey"
extension Array {
    var category:String? {
        get {
            return (objc_getAssociatedObject(self, &ArrayCategoryKey) as? String)
        }set(new){
            objc_setAssociatedObject(self, &ArrayCategoryKey, new, .OBJC_ASSOCIATION_COPY)
        }
    }
}

class HomeViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    private var tbView = UITableView.init(frame: .zero, style: .plain)
    private lazy var day = ""
    private var loading = false
    private var dataArray = [Array<Feed>]()
    private var headView = UIImageView.init(frame: .init(x: 0, y: 0, width: screenwidth, height: 200))
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
        let fmt = DateFormatter.init()
        fmt.dateFormat = "yyyy/MM/dd"
        let date = Date.init()
        day = fmt.string(from: date)
    }
    override func createUI() {
        tbView.delegate = self
        tbView.dataSource = self
        tbView.backgroundColor = .clear
        tbView.tableFooterView = UIView()
        tbView.separatorInset = .zero
        view.addSubview(tbView)
        tbView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        weak var wkself = self
        tbView.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            wkself?.downloadData()
        })
        tbView.tableHeaderView = headView
    }
    override func downloadData() {
        if loading {
            return
        }
        loading = true
        HUD.show(HUDContentType.progress)
        weak var wkself = self
        Networking.shared.get(url: url_history, success: { (history) in
            guard let results = history["results"] as? Array<String> else {
                wkself?.tbView.mj_header.endRefreshing()
                HUD.flash(.label("请稍后重试"))
                wkself?.loading = false
                return
            }
            if results.count > 0 {
                wkself?.day = results[0]
            }
            wkself?.day = wkself!.day.replacingOccurrences(of: "-", with: "/")
            let url_feed = String.init(format: url_today + "%@", wkself!.day)
            Networking.shared.get(url: url_feed, success: { (feedInfo) in
                guard let feeds = feedInfo["results"] as? Dictionary<String,Array<Dictionary<String,Any>>> else {
                    wkself?.tbView.mj_header.endRefreshing()
                    HUD.flash(.label("请稍后重试"))
                    wkself?.loading = false
                    return
                }
                var groupedArray = [Array<Feed>]()
                for pair in feeds {
                    let values = pair.value
                    if pair.key == FeedType.welfare.rawValue {
                        if values.count > 0  {
                            let first = values[0]
                            let feed = Mapper<Feed>.init().map(JSON: first)
                            if feed?.url != nil {
                                wkself?.headView.sd_setImage(with: URL.init(string: feed!.url!), completed: { (image, _, _, _) in
                                    guard image != nil else {
                                        return
                                    }
                                    let scale = image!.size.width / image!.size.height
                                    let h = CGFloat(screenwidth) / scale
                                    wkself?.headView.frame = .init(x: 0, y: 0, width: CGFloat(screenwidth), height: h)
                                    wkself?.tbView.tableHeaderView = wkself?.headView
                                })
                            }
                        }
                        continue
                    }
                    var sectionArray = [Feed]()
                    for dict in values {
                        let f = Mapper<Feed>.init().map(JSON: dict)
                        if f != nil {
                            sectionArray.append(f!)
                        }
                    }
                    sectionArray.category = pair.key
                    groupedArray.append(sectionArray)
                }
                objc_sync_enter(wkself!.dataArray)
                wkself?.dataArray.removeAll()
                wkself?.dataArray.append(contentsOf: groupedArray)
                objc_sync_exit(wkself!.dataArray)
                wkself?.tbView.mj_header.endRefreshing()
                wkself?.tbView.reloadData()
                HUD.hide()
                wkself?.loading = false
            }, failure: { (e) in
                wkself?.tbView.mj_header.endRefreshing()
                HUD.flash(.label(e.localizedDescription))
                wkself?.loading = false
            })
        }, failure: { (error) in
            wkself?.tbView.mj_header.endRefreshing()
            HUD.flash(.label(error.localizedDescription))
            wkself?.loading = false
        })
    }
}
extension HomeViewController {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let array = dataArray[section]
        return array.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section < dataArray.count - 1 {
            return 20
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section < dataArray.count - 1 {
            let footer = UIView.init(frame: .init(x: 0, y: 0, width: screenwidth, height: 20))
            return footer
        }
        return nil
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView.init(frame: .init(x: 0, y: 0, width: screenwidth, height: 30))
        header.backgroundColor = .white
        var name:String? = ""
        if dataArray.count > section {
            let array = dataArray[section]
            name = array.category
        }
        let nameLb = UILabel.init()
        nameLb.text = name
        nameLb.font = boldFont(16)
        nameLb.textColor = rgb(70)
        header .addSubview(nameLb)
        nameLb.snp.makeConstraints { (make) in
            make.left.equalTo(header).offset(20)
            make.top.bottom.equalTo(header)
            make.right.equalTo(header).offset(-20)
        }
        let line = UIView.init()
        line.backgroundColor = rgb(200)
        header.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(header)
            make.height.equalTo(0.5)
        }
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "feed_cid") as? FeedCell
        if cell == nil {
            cell = FeedCell.init(style: .default, reuseIdentifier: "feed_cid")
        }
        var feed:Feed? = nil
        if dataArray.count > indexPath.section {
            let array = dataArray[indexPath.section]
            if array.count > indexPath.row {
                feed = array[indexPath.row]
            }
        }
        if feed != nil {
            cell?.feed = feed
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var feed:Feed? = nil
        if dataArray.count > indexPath.section {
            let array = dataArray[indexPath.section]
            if array.count > indexPath.row {
                feed = array[indexPath.row]
            }
        }
        guard feed != nil else {
            return
        }
        let detail = FeedDetailViewController()
        detail.feed = feed
        navigationController?.pushViewController(detail, animated: true)
    }
}

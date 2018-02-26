//
//  FavoritesViewController.swift
//  geek
//
//  Created by xgf on 2018/2/22.
//  Copyright © 2018年 xgf. All rights reserved.
//

import UIKit
import ObjectMapper

class FavoritesViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var tbView = UITableView.init(frame: .zero, style: .plain)
    private var dataArray = [Array<Feed>]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    override func setup() {
        title = "我的收藏"
    }
    override func createUI() {
        tbView.delegate = self
        tbView.dataSource = self
        tbView.backgroundColor = .clear
        tbView.tableFooterView = UIView.init()
        view.addSubview(tbView)
        tbView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
    }
    private func loadData() {
        guard let favorites = DBManager.shared.entitys() else {
            return
        }
        var groupedArray = [Array<Favorites>]()
        var i = 0
        while i < favorites.count {
            let f1 = favorites[i]
            var j = i + 1
            var len = 1
            var sectionArray = [Favorites]()
            sectionArray.append(f1)
            while j < favorites.count {
                let f2 = favorites[j]
                if f1.type != f2.type {
                    break
                }
                sectionArray.append(f2)
                j += 1
                len += 1
            }
            sectionArray.category = f1.type
            groupedArray.append(sectionArray)
            i += len
        }
        let tmpMap:[String:Any] = ["_id": "",
                                   "createdAt": "",
                                   "desc": "",
                                   "publishedAt": "",
                                   "source": "",
                                   "type": "",
                                   "url": "",
                                   "used": true,
                                   "who": ""]
        for array in groupedArray {
            var tmpArray = [Feed]()
            for entity in array {
                let feed = Mapper<Feed>.init().map(JSON: tmpMap)
                feed?.desc = entity.desc
                feed?.id = entity.id
                feed?.url = entity.url
                feed?.source = entity.source
                feed?.type = entity.type
                feed?.used = entity.used
                feed?.who = entity.who
                feed?.publishedAt = entity.publishedAt
                feed?.createdAt = entity.createdAt
                if feed != nil {
                    tmpArray.append(feed!)
                }
            }
            tmpArray.category = tmpArray.first?.type
            objc_sync_enter(dataArray)
            dataArray.append(tmpArray)
            objc_sync_exit(dataArray)
            tbView.reloadData()
        }
    }
}
extension FavoritesViewController {
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
        detail.shouldShowFavoriteBtn = false
        navigationController?.pushViewController(detail, animated: true)
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        guard dataArray.count > indexPath.section else {
            return
        }
        guard dataArray[indexPath.section].count > indexPath.row else {
            return
        }
        let feed = dataArray[indexPath.section][indexPath.row]
        objc_sync_enter(dataArray)
        dataArray[indexPath.section].remove(at: indexPath.row)
        if dataArray[indexPath.section].count == 0 {
            dataArray.remove(at: indexPath.section)
        }
        objc_sync_exit(dataArray)
        DBManager.shared.deleteById(feed.id)
        DBManager.shared.save()
        tbView.reloadData()
    }
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
}

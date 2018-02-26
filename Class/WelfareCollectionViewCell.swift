//
//  WelfareCollectionViewCell.swift
//  geek
//
//  Created by xgf on 2018/2/23.
//  Copyright © 2018年 xgf. All rights reserved.
//

import UIKit
import PKHUD
import ObjectMapper
import SDWebImage
import MJRefresh

class WelfareCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    private var collectionView:UICollectionView?
    private var dataArray = [Feed]()
    var navi:UINavigationController?
    private var loading = false
    private var page = 1
    var category: String? {
        didSet {
            if dataArray.count > 0 {
                return
            }
            collectionView?.mj_header.endRefreshing()
            collectionView?.mj_footer.endRefreshing()
            objc_sync_enter(dataArray)
            dataArray.removeAll()
            objc_sync_exit(dataArray)
            collectionView?.reloadData()
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
        let layout = WelfareCollectionViewLayout.init()
        weak var wkself = self
        layout.heigt = { (indexPath) -> CGFloat in
            if indexPath.item > wkself!.dataArray.count {
                return 100
            }
            guard let link = wkself?.dataArray[indexPath.item].url else {
                return 100
            }
            let key = SDWebImageManager.shared().cacheKey(for: URL.init(string: link))
            guard let image = SDImageCache.shared().imageFromMemoryCache(forKey: key) else {
                return 100
            }
            let h = (CGFloat(screenwidth)/3.0)/(image.size.width/image.size.height)
            return h
        }
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.backgroundColor = .clear
        contentView.addSubview(collectionView!)
        collectionView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.contentView)
        })
        collectionView?.register(UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "welfare_cid")
        collectionView?.mj_header = MJRefreshNormalHeader.init(refreshingBlock: {
            wkself?.page = 1
            wkself?.donwloadData()
        })
        collectionView?.mj_footer = MJRefreshBackNormalFooter.init(refreshingBlock: {
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
                wkself?.collectionView?.mj_header.endRefreshing()
                wkself?.collectionView?.mj_footer.endRefreshing()
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
            wkself?.collectionView?.mj_header.endRefreshing()
            wkself?.collectionView?.mj_footer.endRefreshing()
            wkself?.collectionView?.reloadData()
            wkself?.loading = false
        }, failure: { (error) in
            wkself?.collectionView?.mj_header.endRefreshing()
            wkself?.collectionView?.mj_footer.endRefreshing()
            HUD.flash(.labeledError(title: nil, subtitle: error.localizedDescription))
            if wkself!.page > 1 {
                wkself?.page -= 1
            }
            wkself?.loading = false
        })
    }
}
extension WelfareCollectionViewCell {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "welfare_cid", for: indexPath)
        cell.backgroundColor = .clear
        cell.contentView.subviews.forEach{
            $0.removeFromSuperview()
        }
        let feed = dataArray[indexPath.item]
        if feed.url != nil {
            let imv = UIImageView.init()
            imv.sd_setImage(with: URL.init(string: feed.url!), completed: nil)
            cell.contentView.addSubview(imv)
            imv.snp.makeConstraints({ (make) in
                make.edges.equalTo(cell.contentView)
            })
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var photos = [SKPhoto]()
        dataArray.forEach{
            if $0.url != nil {
                let p = SKPhoto.init(url: $0.url!)
                photos.append(p)
            }
        }
        let browser = SKPhotoBrowser.init(photos: photos)
        browser.currentPageIndex = indexPath.item
        navi?.present(browser, animated: true, completion: nil)
    }
}


//
//  FeedDetailViewController.swift
//  geek
//
//  Created by xgf on 2018/2/22.
//  Copyright © 2018年 xgf. All rights reserved.
//

import UIKit
import PKHUD

class FeedDetailViewController: BaseViewController,UIWebViewDelegate {
    private var web = UIWebView.init()
    var feed:Feed?
    var shouldShowFavoriteBtn = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func setup() {
        if feed?.desc != nil {
            title = feed?.desc
        } else {
            title = "详情"
        }
        guard shouldShowFavoriteBtn else {
            return
        }
        let favoriteBtn = UIButton.init(frame: .init(x: 0, y: 0, width: 40, height: 44))
        favoriteBtn.setImage(UIImage.init(named: "star"), for: .normal)
        favoriteBtn.contentHorizontalAlignment = .right
        weak var wkself = self
        favoriteBtn.handleClick(events: .touchUpInside, click: { (sender) in
            guard let f = wkself?.feed else {
                return
            }
            guard let id = f.id else {
                return
            }
            let entity = DBManager.shared.entityWithId(id)
            if entity != nil {
                HUD.flash(.labeledError(title: nil, subtitle: "你已收藏过这篇文章啦~"))
                return
            }
            DBManager.shared.insert(feed: f)
            DBManager.shared.save()
            HUD.flash(.success)
        })
        let item = UIBarButtonItem.init(customView: favoriteBtn)
        navigationItem.rightBarButtonItem = item
    }
    override func createUI() {
        web.delegate = self
        web.scalesPageToFit = true
        view.addSubview(web)
        web.snp.makeConstraints { (make) in
            make.edges.equalTo(self.view)
        }
        guard let link = feed?.url else {
            return
        }
        let url = URL.init(string: link)
        guard url != nil else {
            return
        }
        let requeset = URLRequest.init(url: url!)
        web.loadRequest(requeset)
    }
    override func backButtonClickAction() {
        if web.canGoBack {
            web.goBack()
            return
        }
        if web.isLoading {
            web.stopLoading()
        }
        navigationController?.popViewController(animated: true)
    }
}

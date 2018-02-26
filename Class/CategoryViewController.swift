
//
//  CategoryViewController.swift
//  geek
//
//  Created by xgf on 2018/2/22.
//  Copyright © 2018年 xgf. All rights reserved.
//

import UIKit

class CategoryViewController: BaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    private var collectionView:UICollectionView?
    private var categorys:[FeedType] = [.ios,.android,.web,.lib,.vedio,.welfare]
    private var tagView = UIView.init()
    private var topScrollView = UIScrollView.init(frame: .init(x: 0, y: navih8(), width: screenwidth, height: 40))
    private var naviLine:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func preferedBackButtonHidden() -> Bool {
        return true
    }
    override func setup() {
        automaticallyAdjustsScrollViewInsets = false
        naviLine = findNaviLine(navigationController!.navigationBar)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        naviLine?.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        naviLine?.isHidden = false
    }
    private func findNaviLine(_ inView:UIView) -> UIImageView? {
        if inView is UIImageView &&  inView.bounds.size.height <= 1.0 {
            return inView as? UIImageView
        }
        for sub in inView.subviews {
            let imv = findNaviLine(sub)
            if imv != nil {
                return imv!
            }
        }
        return nil
    }
    override func createUI() {
        topScrollView.backgroundColor = .white
        topScrollView.showsHorizontalScrollIndicator = false
        view.addSubview(topScrollView)
        
        let marginx:CGFloat = 10
        let gapx:CGFloat = 20
        var xpos:CGFloat = marginx
        var firstWidth:CGFloat = 40
        for i in 0 ..< categorys.count {
            let btn = UIButton.init()
            btn.setTitle(categorys[i].rawValue, for: .normal)
            btn.titleLabel?.font = font14
            let width = btn.titleLabel!.sizeThatFits(.init(width: .greatestFiniteMagnitude, height: 20.0)).width
            firstWidth = width
            btn.setTitleColor(rgb(70), for: .normal)
            btn.tag = 100 + i
            btn.addTarget(self, action: #selector(categoryBtnClickAction(_:)), for: .touchUpInside)
            topScrollView.addSubview(btn)
            btn.snp.makeConstraints({ (make) in
                make.left.equalTo(xpos)
                make.top.bottom.equalTo(topScrollView)
                make.width.equalTo(width)
            })
            xpos += (width + gapx)
        }
        let h = CGFloat(screenheight - navih8() - 40 - 49)
        topScrollView.contentSize = .init(width: xpos, height: 40)
        
        let line = UIView.init()
        line.backgroundColor = rgb(200)
        view.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.bottom.equalTo(topScrollView)
            make.width.equalTo(screenwidth)
            make.height.equalTo(0.5)
        }
        
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = .init(width: CGFloat(screenwidth), height: h)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.backgroundColor = .clear
        view.addSubview(collectionView!)
        collectionView?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.topScrollView.snp.bottom)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-49)
        })
        collectionView?.register(CategoryCollectionCell.classForCoder(), forCellWithReuseIdentifier: "category_cid")
        collectionView?.register(WelfareCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "welfare_cid")
        tagView.backgroundColor = rgb(70)
        tagView.layer.cornerRadius = 1
        view.addSubview(tagView)
        tagView.frame = CGRect.init(x: marginx, y: CGFloat(navih8()) + 38, width: firstWidth, height: 2.0)
    }
    @objc private func categoryBtnClickAction(_ sender:UIButton) {
        let tag = sender.tag - 100
        collectionView?.contentOffset = .init(x: tag * screenwidth, y: 0)
    }
}
extension CategoryViewController {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categorys.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let type = categorys[indexPath.item]
        if type != .welfare {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "category_cid", for: indexPath) as! CategoryCollectionCell
            cell.category = type.rawValue
            cell.navi = navigationController
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "welfare_cid", for: indexPath) as! WelfareCollectionViewCell
            cell.category = type.rawValue
            cell.navi = navigationController
            return cell
        }
    }
}
extension CategoryViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == collectionView else {
            return
        }
        let page = Int(scrollView.contentOffset.x) / screenwidth
        var frm = tagView.frame
        let marginx:CGFloat = 10
        let gapx:CGFloat = 20
        var xpos:CGFloat = marginx
        for i in 0 ..< page {
            let name = categorys[i].rawValue
            let lb = UILabel.init()
            lb.text = name
            lb.font = font14
            let w = lb.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: 20)).width
            xpos += (w + gapx)
        }
        frm.origin.x = xpos
        let tmp = categorys[page].rawValue
        let tmpLb = UILabel.init()
        tmpLb.text = tmp
        tmpLb.font = font14
        let tmpWidth = tmpLb.sizeThatFits(.init(width: CGFloat.greatestFiniteMagnitude, height: 20)).width
        frm.size.width = tmpWidth
        tagView.frame = frm
    }
}

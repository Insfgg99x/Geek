//
//  FeedCell.swift
//  geek
//
//  Created by xgf on 2018/2/22.
//  Copyright © 2018年 xgf. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {
    private var titleLb = UILabel.init()
    private var dateLb = UILabel.init()
    private var sourceLb = UILabel.init()
    
    var feed:Feed? {
        didSet {
            refreshUI()
        }
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
        createUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setup() {
        selectionStyle = .none
    }
    private func createUI() {
        titleLb.font = font14
        titleLb.numberOfLines = 0
        contentView.addSubview(titleLb)
        titleLb.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView).offset(10)
            make.right.equalTo(self.contentView).offset(-10)
            make.top.equalTo(self.contentView).offset(10)
            make.height.equalTo(20)
        }
        
        dateLb.textColor = .darkGray
        dateLb.font = font12
        contentView.addSubview(dateLb)
        dateLb.snp.makeConstraints { (make) in
            make.left.equalTo(self.titleLb)
            make.bottom.equalTo(self.contentView).offset(-10)
            make.width.equalTo(120)
            make.height.equalTo(10)
        }
        
        sourceLb.textColor = .darkGray
        sourceLb.font = font12
        sourceLb.textAlignment = .right
        contentView.addSubview(sourceLb)
        sourceLb.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-10)
            make.bottom.height.equalTo(self.dateLb)
            make.width.equalTo(160)
            
        }
    }
    private func refreshUI() {
        guard feed != nil else {
            return
        }
        if feed?.desc == nil {
            titleLb.text = "无标题"
        } else {
            titleLb.text = feed?.desc
            var height = titleLb.sizeThatFits(CGSize.init(width: CGFloat(screenwidth) - 20, height: .greatestFiniteMagnitude)).height
            if height < 20 {
                height = 20
            } else if height > 40 {
                height = 40
            }
            titleLb.snp.updateConstraints({ (make) in
                make.height.equalTo(height)
            })
        }
        if feed?.source != nil {
            if feed?.url?.range(of: "github") != nil {
                sourceLb.text = "GitHub"
            } else {
                sourceLb.text = feed?.source?.capitalized
            }
        }
        if feed?.publishedAt != nil {
            if (feed?.publishedAt)!.count >= 10 {
                let index = (feed?.publishedAt)!.index((feed?.publishedAt)!.startIndex, offsetBy: 10)
                let time = String((feed?.publishedAt)![..<index])
                dateLb.text = time
            }
        }
    }
}

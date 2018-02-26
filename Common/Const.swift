//
//  Const.swift
//  geek
//
//  Created by xgf on 2018/2/22.
//  Copyright © 2018年 xgf. All rights reserved.
//

import Foundation
import UIKit

let kAddMobAppID    = "ca-app-pub-3100690667169836~7496197283"
let kAddMobAdUnitID = "ca-app-pub-3100690667169836/6966139273"

var screenwidth  =  Int(UIScreen.main.bounds.size.width)
var screenheight =  Int(UIScreen.main.bounds.size.height)
let font8        =  UIFont.systemFont(ofSize: 8)
let font9        =  UIFont.systemFont(ofSize: 9)
let font10       =  UIFont.systemFont(ofSize: 10)
let font11       =  UIFont.systemFont(ofSize: 11)
let font12       =  UIFont.systemFont(ofSize: 12)
let font13       =  UIFont.systemFont(ofSize: 13)
let font14       =  UIFont.systemFont(ofSize: 14)
let font15       =  UIFont.systemFont(ofSize: 15)
let font16       =  UIFont.systemFont(ofSize: 16)
let font17       =  UIFont.systemFont(ofSize: 17)
let font18       =  UIFont.systemFont(ofSize: 19)
let font19       =  UIFont.systemFont(ofSize: 19)
let font20       =  UIFont.systemFont(ofSize: 20)

public func boldFont(_ f:Float) -> UIFont {
    return UIFont.boldSystemFont(ofSize: CGFloat(f))
}
public func navih8() ->Int {//navi height
    if UIScreen.main.bounds.size.height == 812 {
        return 88
    }
    return 64
}
public func rgb(_ r:Int, _ g:Int, _ b:Int) ->UIColor {
    return UIColor.init(red:CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: 1.0)
}
public func rgba(_ r:Int, _ g:Int, _ b:Int, _ a:CGFloat) ->UIColor {
    return UIColor.init(red:CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: a)
}
public func rgb(_ rgb:UInt) -> UIColor {
    return UIColor.init(red:CGFloat(rgb)/255.0, green: CGFloat(rgb)/255.0, blue: CGFloat(rgb)/255.0, alpha: 1.0)
}
enum FeedType: String {
    case ios = "iOS"
    case web =  "前端"
    case android = "Android"
    case vedio = "休息视频"
    case lib = "拓展资源"
    case welfare = "福利"
}

let itunesconnectId = "1352220020"
let url_appstore    = "https://itunes.apple.com/cn/app/Geek-gan-huo/id1352220020?mt=8"
let url_history     = "http://gank.io/api/day/history"
let url_today       = "http://gank.io/api/day/"
let url_category    = "http://gank.io/api/data/%@/20/%d"


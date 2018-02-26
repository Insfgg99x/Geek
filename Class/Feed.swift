//
//  Feed.swift
//  geek
//
//  Created by xgf on 2018/2/22.
//  Copyright © 2018年 xgf. All rights reserved.
//

import UIKit
import ObjectMapper

class Feed: NSObject,Mappable {
    var id:String?
    var createdAt:String?
    var desc:String?
    var publishedAt:String?
    var source:String?
    var type:String?
    var url:String?
    var used:Bool?
    var who:String?
    
    required init?(map: Map) {
        super.init()
    }
    func mapping(map: Map) {
        id          <- map["_id"]
        createdAt   <- map["createdAt"]
        desc        <- map["desc"]
        publishedAt <- map["publishedAt"]
        source      <- map["source"]
        type        <- map["type"]
        url         <- map["url"]
        used        <- map["used"]
        who         <- map["who"]
    }
}

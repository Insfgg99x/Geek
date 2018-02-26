//
//  Networking.swift
//  FriendCircle
//
//  Created by xgf on 2018/1/18.
//  Copyright © 2018年 HuaZhongShiXun. All rights reserved.
//

import UIKit

class Networking: NSObject {
    static let shared = Networking.init()
    
    func post(url:String, param:String?, success:((Dictionary<String, Any>) -> ())?, failure:((Error) -> ())?) {
        let _url = URL.init(string: url)
        var request = URLRequest.init(url: _url!)
        request.httpMethod = "POST"
        if(param != nil) {
            request.httpBody = param!.data(using: .utf8)
        }
        request.timeoutInterval = 30
        URLSession.shared.dataTask(with: request, completionHandler: { (data,response,error) in
            guard error == nil else {
                if failure != nil {
                    DispatchQueue.main.async {
                        failure?(error!)
                    }
                }
                return
            }
            guard data != nil else {
                let e = NSError.init(domain: NSStringFromClass(self.classForCoder), code: -1, userInfo: [NSLocalizedDescriptionKey:"获取不到数据"])
                if failure != nil {
                    DispatchQueue.main.async {
                        failure?(e)
                    }
                }
                return
            }
            guard data!.count > 0 else {
                let e = NSError.init(domain: NSStringFromClass(self.classForCoder), code: -1, userInfo: [NSLocalizedDescriptionKey:"获取不到数据"])
                if failure != nil {
                    DispatchQueue.main.async {
                        failure?(e)
                    }
                }
                return
            }
            var obj:Dictionary<String,Any>? = nil
            do {
                obj = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? Dictionary<String, Any>
            }catch let e {
                if failure != nil {
                    DispatchQueue.main.async {
                        failure?(e)
                    }
                }
                return
            }
            guard obj != nil else {
                let e = NSError.init(domain: NSStringFromClass(self.classForCoder), code: -1, userInfo: [NSLocalizedDescriptionKey:"服务器内部错误"])
                if failure != nil {
                    DispatchQueue.main.async {
                        failure?(e)
                    }
                }
                return
            }
            if success != nil {
                DispatchQueue.main.async {
                    success?(obj!)
                }
            }
        }).resume()
    }
    func get(url:String, success:((Dictionary<String, Any>) -> ())?, failure:((Error) -> ())?) {
        let _url = URL.init(string: url)
        guard _url != nil else {
            let e = NSError.init(domain: NSStringFromClass(self.classForCoder), code: -2, userInfo: [NSLocalizedDescriptionKey:"url格式错误"])
            if failure != nil {
                DispatchQueue.main.async {
                    failure?(e)
                }
            }
            return
        }
        var requeset = URLRequest.init(url: _url!)
        requeset.timeoutInterval = 20
        requeset.httpMethod = "GET"
        URLSession.shared.dataTask(with: requeset, completionHandler: { (data, _, error) in
            guard error == nil else {
                if failure != nil {
                    DispatchQueue.main.async {
                        failure?(error!)
                    }
                }
                return
            }
            guard data != nil else {
                let e = NSError.init(domain: NSStringFromClass(self.classForCoder), code: -1, userInfo: [NSLocalizedDescriptionKey:"获取不到数据"])
                if failure != nil {
                    DispatchQueue.main.async {
                        failure?(e)
                    }
                }
                return
            }
            guard data!.count > 0 else {
                let e = NSError.init(domain: NSStringFromClass(self.classForCoder), code: -1, userInfo: [NSLocalizedDescriptionKey:"获取不到数据"])
                if failure != nil {
                    DispatchQueue.main.async {
                        failure?(e)
                    }
                }
                return
            }
            var obj:Dictionary<String,Any>? = nil
            do {
                obj = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? Dictionary<String, Any>
            }catch let e {
                if failure != nil {
                    DispatchQueue.main.async {
                        failure?(e)
                    }
                }
                return
            }
            guard obj != nil else {
                let e = NSError.init(domain: NSStringFromClass(self.classForCoder), code: -1, userInfo: [NSLocalizedDescriptionKey:"服务器内部错误"])
                if failure != nil {
                    DispatchQueue.main.async {
                        failure?(e)
                    }
                }
                return
            }
            if success != nil {
                DispatchQueue.main.async {
                    success?(obj!)
                }
            }
        }).resume()
    }
}

//
//  SKCache.swift
//  SKPhotoBrowser
//
//  Created by Kevin Wolkober on 6/13/16.
//  Copyright © 2016 suzuki_keishi. All rights reserved.
//

import UIKit

open class SKCache {
    open static let sharedCache = SKCache()
    open var imageCache: SKCacheable

    init() {
        self.imageCache = SKDefaultImageCache()
    }

    open func imageDataForKey(_ key: String) -> Data? {
        guard let cache = imageCache as? SKImageCacheable else {
            return nil
        }
        
        return cache.imageDataForKey(key)
    }

    open func setImageData(_ data: Data, forKey key: String) {
        guard let cache = imageCache as? SKImageCacheable else {
            return
        }
        
        cache.setImageData(data, forKey: key)
    }

    open func removeImageDataForKey(_ key: String) {
        guard let cache = imageCache as? SKImageCacheable else {
            return
        }
        
        cache.removeImageDataForKey(key)
    }

    open func imageDataForRequest(_ request: URLRequest) -> Data? {
        guard let cache = imageCache as? SKRequestResponseCacheable else {
            return nil
        }
        
        if let response = cache.cachedResponseForRequest(request) {
            
            return response.data
        }
        return nil
    }

    open func setImageData(_ data: Data, response: URLResponse, request: URLRequest?) {
        guard let cache = imageCache as? SKRequestResponseCacheable, let request = request else {
            return
        }
        let cachedResponse = CachedURLResponse(response: response, data: data)
        cache.storeCachedResponse(cachedResponse, forRequest: request)
    }
}

class SKDefaultImageCache: SKImageCacheable {

    var cache: NSCache<AnyObject, AnyObject>

    init() {
        cache = NSCache()
    }

    func imageDataForKey(_ key: String) -> Data? {
        
        return cache.object(forKey: key as AnyObject) as? Data
    }

    func setImageData(_ data: Data, forKey key: String) {
        
        cache.setObject(data as AnyObject, forKey: key as AnyObject)
    }

    func removeImageDataForKey(_ key: String) {
        
        cache.removeObject(forKey: key as AnyObject)
    }
}

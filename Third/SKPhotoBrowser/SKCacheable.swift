//
//  SKCacheable.swift
//  SKPhotoBrowser
//
//  Created by Kevin Wolkober on 6/13/16.
//  Copyright © 2016 suzuki_keishi. All rights reserved.
//

import UIKit.UIImage

public protocol SKCacheable {}
public protocol SKImageCacheable: SKCacheable {
    
    func imageDataForKey(_ key: String) -> Data?
    func setImageData(_ data: Data, forKey key: String)
    func removeImageDataForKey(_ key: String)
}

public protocol SKRequestResponseCacheable: SKCacheable {
    func cachedResponseForRequest(_ request: URLRequest) -> CachedURLResponse?
    func storeCachedResponse(_ cachedResponse: CachedURLResponse, forRequest request: URLRequest)
}

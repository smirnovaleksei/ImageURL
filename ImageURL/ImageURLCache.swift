//
//  ImageURLCache.swift
//  ImageURL
//
//  Created by Aleksei Smirnov on 09.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

final class ImageURLCache: URLCache {

    static var current = ImageURLCache()

    override init() {
        let MB = 1024 * 1024
        super.init(
            memoryCapacity: 2 * MB,
            diskCapacity: 100 * MB,
            diskPath: "imageCache"
        )
    }

    private static let accessQueue = DispatchQueue(
        label: "com.smirnov-development.image-urlcache-access"
    )

    public override func cachedResponse(for request: URLRequest) -> CachedURLResponse? {
        ImageURLCache.accessQueue.sync {
            return super.cachedResponse(for: request)
        }
    }

    public override func storeCachedResponse(_ response: CachedURLResponse, for request: URLRequest) {
        ImageURLCache.accessQueue.sync {
            return super.storeCachedResponse(response, for: request)
        }
    }
}

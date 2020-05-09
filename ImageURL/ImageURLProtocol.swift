//
//  ImageURLProtocol.swift
//  ImageURL
//
//  Created by Aleksei Smirnov on 09.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import Foundation

final class ImageURLProtocol: URLProtocol {

    private var cancelledOrComplete = false
    private var block: DispatchWorkItem?
    private static let queue = OS_dispatch_queue_serial(label: "com.smirnov-development.imageURL-protocol")

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    class override func requestIsCacheEquivalent(_ aRequest: URLRequest, to bRequest: URLRequest) -> Bool {
        return false
    }


    final override func startLoading() {

        guard let reqURL = request.url, let urlClient = client else {
            fail(with: .badURL)
            return
        }

        if let cachedResponse = cachedResponse {
            print("take from cache")
            complete(with: cachedResponse)
        } else {
            print("load image")
            load(with: reqURL, urlClient: urlClient)
        }
    }

    final override func stopLoading() {
        ImageURLProtocol.queue.async {
            if self.cancelledOrComplete == false, let cancelBlock = self.block {
                cancelBlock.cancel()
                self.cancelledOrComplete = true
            }
        }
    }

    private func load(with reqURL: URL, urlClient: URLProtocolClient) {

        block = DispatchWorkItem(block: {
            if self.cancelledOrComplete == false {
                do {
                    let data = try Data(contentsOf: reqURL)
                    self.handle(data: data, error: nil)
                } catch let error {
                    self.handle(data: nil, error: error)
                }
            }
            self.cancelledOrComplete = true
        })

        guard let block = block else { return }
        ImageURLProtocol.queue.async(execute: block)
    }

    func handle(data: Data?, error: Error?) {
        if let data = data {
            self.complete(with: data)
        } else if let error = error {
            self.fail(with: error)
        }
    }

    func complete(with cachedResponse: CachedURLResponse) {
        complete(with: cachedResponse.data)
    }

    func complete(with data: Data) {

        guard let url = request.url, let client = client else {
            return
        }

        let response = URLResponse(
            url: url,
            mimeType: "image/jpeg",
            expectedContentLength: data.count,
            textEncodingName: nil
        )

        client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .allowed)
        client.urlProtocol(self, didLoad: data)
        client.urlProtocolDidFinishLoading(self)
    }

    func fail(with errorCode: URLError.Code) {
        let error = URLError(errorCode, userInfo: [:])
        fail(with: error)
    }

    func fail(with error: Error) {
        client?.urlProtocol(self, didFailWithError: error)
    }
}


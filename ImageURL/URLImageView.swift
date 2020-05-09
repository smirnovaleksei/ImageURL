//
//  URLImageView.swift
//  ImageURL
//
//  Created by Aleksei Smirnov on 09.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

fileprivate let config: URLSessionConfiguration = {
    let config = URLSessionConfiguration.ephemeral
    config.urlCache = ImageURLCache.current
    config.protocolClasses = [ImageURLProtocol.classForCoder()]
    return config
}()

fileprivate let session = URLSession(
    configuration: config,
    delegate: nil,
    delegateQueue: nil
)

final class URLImageView: UIImageView, URLSessionDataDelegate {
    
    private var task: URLSessionDataTask?
    private var taskId: Int?

    func prepareForReuse() {
        task?.cancel()
        taskId = nil
        image = nil
    }

    private func complete(taskId: Int?, data: Data?, response: URLResponse?, error: Error?) {
        if self.taskId == taskId,
            let data = data,
            let image = UIImage(data: data, scale: UIScreen.main.scale) {
            didLoadRemote(image: image)
        }
    }

    private func didLoadRemote(image: UIImage) {
        DispatchQueue.main.async {
            self.image = image
        }
    }

    func render(url: String) {
        assert(task == nil || task?.taskIdentifier != taskId)
        if let url = URL(string: url) {
            
            var id: Int?

            let request = URLRequest(
                url: url,
                cachePolicy: .returnCacheDataElseLoad,
                timeoutInterval: 30
            )

            task = session.dataTask(with: request, completionHandler: { [weak self] data, response, error in
                self?.complete(taskId: id, data: data, response: response, error: error)
            })

            id = task?.taskIdentifier
            taskId = id
            task?.resume()
        }
    }
}

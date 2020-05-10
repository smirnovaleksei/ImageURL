//
//  URLImageView.swift
//  ImageURL
//
//  Created by Aleksei Smirnov on 09.05.2020.
//  Copyright © 2020 Aleksei Smirnov. All rights reserved.
//

import UIKit

final class URLImageView: UIImageView, URLSessionDataDelegate {

    // MARK: - Private Properties

    private var task: URLSessionDataTask? {
        didSet {
            if task != nil {
                if ImageURLProtocol.executing.contains(where: { (executingTask) -> Bool in
                    executingTask.currentRequest == task?.currentRequest
                }) {
                    ImageURLProtocol.suspended.append(task!)
                    return
                }
                ImageURLProtocol.executing.append(task!)
                task?.resume()
            }
        }
    }
    private var taskId: Int?

    // MARK: - Public Methods

    func render(url: String) {
        assert(task == nil || task?.taskIdentifier != taskId)
        if let url = URL(string: url) {

            var id: Int?

            let request = URLRequest(
                url: url,
                cachePolicy: .returnCacheDataElseLoad,
                timeoutInterval: 30
            )

            task = ImageURLProtocol.session.dataTask(with: request, completionHandler: { [weak self] data, response, error in
                self?.complete(taskId: id, data: data, response: response, error: error)
                DispatchQueue.main.async {
                    ImageURLProtocol.executing.removeAll(where: { $0.taskIdentifier == id })
                }
            })

            id = task?.taskIdentifier
            taskId = id
        }
    }

    func prepareForReuse() {
        task?.cancel()
        taskId = nil
        image = nil
    }

    // MARK: - Private Methods

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
}

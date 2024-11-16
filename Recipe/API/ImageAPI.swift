//
//  ImageAPI.swift
//  Recipe
//
//  Created by Dylan Nienberg on 11/14/24.
//

import Combine
import Foundation

class ImageAPI: ObservableObject {
    let objectWillChange = ObservableObjectPublisher()
    private var imageURL: URL?
    
    var data: Data = Data() {
        willSet {
            self.objectWillChange.send()
        }
    }
    
    func fetchImage(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60.0)
        let session = URLSession.shared

        let task = session.dataTask(with: request) { data, response, error in
            if let data = data, let response = response {
                // Save the response in cache
                let cachedResponse = CachedURLResponse(response: response, data: data)
                URLCache.shared.storeCachedResponse(cachedResponse, for: request)
            }
            completion(data, response, error)
        }
        task.resume()
    }
    
    func getCachedImage(for url: URL) -> Data? {
        let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 60.0)
        if let cachedResponse = URLCache.shared.cachedResponse(for: request) {
            return cachedResponse.data
        }
        return nil
    }

    func fetchImageWithCacheCheck() {
        if let imageURL = imageURL {
            if let cachedData = getCachedImage(for: imageURL) {
                DispatchQueue.main.async { [weak self] in
                    self?.data = cachedData
                }
            } else {
                fetchImage(from: imageURL) { data, _, _ in
                    if let data = data {
                        DispatchQueue.main.async { [weak self] in
                            self?.data = data
                        }
                    }
                }
            }
        }
    }
    
    init(url: String) {
        guard let url = URL(string: url) else {
            return
        }
        imageURL = url
    }
}

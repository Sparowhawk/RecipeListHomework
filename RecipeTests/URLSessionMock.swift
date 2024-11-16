//
//  URLSessionMock.swift
//  Recipe
//
//  Created by Dylan Nienberg on 11/16/24.
//

import Foundation

class URLSessionMock: URLSession {
    var dataTaskStub: ((URLRequest, (Data?, URLResponse?, Error?) -> Void) -> Void)?

    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        dataTaskStub?(request, completionHandler)
        return URLSessionDataTask()
    }
}

extension URLSessionMock {
    func stubDataTask(with data: Data?, response: URLResponse?, error: Error?) {
        dataTaskStub = { _, completionHandler in
            completionHandler(data, response, error)
        }
    }

    func stubDataTaskWithError(_ error: Error) {
        stubDataTask(with: nil, response: nil, error: error)
    }

    func stubDataTaskWithResponse(_ response: URLResponse) {
        stubDataTask(with: nil, response: response, error: nil)
    }

    func stubDataTaskWithData(_ data: Data) {
        stubDataTask(with: data, response: nil, error: nil)
    }
}

//
//  RecipeAPI.swift
//  Recipe
//
//  Created by Dylan Nienberg on 11/14/24.
//

import Combine
import Foundation

let API_BASE = "https://d3jbb8n5wk0qxi.cloudfront.net/"

enum LoadableState<T: Equatable>: Equatable {
    case loading
    case fetched(Result<T, FetchError>)
        
    static func == (lhs: LoadableState<T>, rhs: LoadableState<T>) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.fetched(let lhsResult), .fetched(let rhsResult)):
            return lhsResult == rhsResult
        default:
            return false
        }
    }
}

enum FetchError: Error, Equatable {
    case error(String)
    
    var localizedDescription: String {
        switch self {
        case .error(let message):
            return message
        }
    }
}

class RecipeListFetcher: ObservableObject {
    var searchQuery: String = "recipes.json" {
        didSet {
            self.update();
        }
    }
    
    let objectWillChange = ObservableObjectPublisher()
    
    var state: LoadableState<Response> = .loading {
        willSet {
            self.objectWillChange.send()
        }
    }
    
    func update() {
        state = .loading
        guard let apiUrl = URL(string: API_BASE + searchQuery) else {
            state = .fetched(.failure(.error("Malformed API URL.")))
            return
        }

        URLSession.shared.dataTask(with: apiUrl) { [weak self] (data, resp, error) in
            if let error = error {
                self?.state = .fetched(.failure(.error(error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                self?.state = .fetched(.failure(.error("Malformed response data")))
                return
            }
            
            let httpResponse = resp as! HTTPURLResponse
            if (httpResponse.statusCode != 200) {
                self?.state = .fetched(.failure(.error("Bad HTTP Response: \(httpResponse.statusCode)")))
                return
            }
            
            let response = try! JSONDecoder().decode(Response.self, from: data)
            
            DispatchQueue.main.async { [weak self] in
                self?.state = .fetched(.success(response))
            }
        }.resume()
    }
    
    init() {
        update()
    }
}

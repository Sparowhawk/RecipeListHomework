//
//  RecipeListFetcherTests.swift
//  Recipe
//
//  Created by Dylan Nienberg on 11/16/24.
//

import XCTest
import Combine
@testable import Recipe

class RecipeAPITests: XCTestCase {

    var cancellable: AnyCancellable?

    override func setUp() {
        super.setUp()
    }

    func testUpdateFetchesData() {
            // Mock URL response
            let jsonData = """
            {
                "recipes": [
                    {
                        "uuid": "123e4567-e89b-12d3-a456-426655440000",
                        "name": "Test Recipe",
                        "cuisine": "Test Cuisine"
                    }
                ]
            }
            """.data(using: .utf8)!

            let response = HTTPURLResponse(url: URL(string: "https://example.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
            
            // Set up mock URLSession
            let session = URLSessionMock()
            session.stubDataTask(with: jsonData, response: response, error: nil)

            // Update recipeAPI
            let recipeAPI = RecipeListFetcher()
            recipeAPI.update()
        
        // Wait for a short period of time to allow the state to be updated
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                // Assert the state
                XCTAssertEqual(recipeAPI.state, .fetched(.success(Response(recipes: [Recipe(uuid: "123e4567-e89b-12d3-a456-426655440000", name: "Test Recipe", cuisine: "Test Cuisine")]))))
            }
        }

        func testUpdateHandlesError() {
            // Mock URL response
            let error = NSError(domain: "TestError", code: 1, userInfo: nil)
            
            // Set up mock URLSession
            let session = URLSessionMock()
            session.stubDataTaskWithError(error)

            // Update recipeAPI
            let recipeAPI = RecipeListFetcher()
            recipeAPI.update()

            // Wait for a short period of time to allow the state to be updated
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                // Assert the state
                XCTAssertEqual(recipeAPI.state, .fetched(.failure(.error("TestError"))))
            }
        }

        func testUpdateHandlesMalformedData() {
            // Mock URL response
            let jsonData = "Malformed data".data(using: .utf8)!
            
            // Set up mock URLSession
            let session = URLSessionMock()
            session.stubDataTask(with: jsonData, response: nil, error: nil)

            // Update recipeAPI
            let recipeAPI = RecipeListFetcher()
            recipeAPI.update()

            // Wait for a short period of time to allow the state to be updated
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                // Assert the state
                XCTAssertEqual(recipeAPI.state, .fetched(.failure(.error("Malformed response data"))))
            }
        }

        func testUpdateHandlesInvalidJSON() {
            // Mock URL response
            let jsonData = """
            {
                "recipes": [
                    {
                        "uuid": "123e4567-e89b-12d3-a456-426655440000",
                        "name": "Test Recipe"
                    }
                ]
            }
            """.data(using: .utf8)!
            
            // Set up mock URLSession
            let session = URLSessionMock()
            session.stubDataTask(with: jsonData, response: nil, error: nil)

            // Update recipeAPI
            let recipeAPI = RecipeListFetcher()
            recipeAPI.update()

            // Wait for a short period of time to allow the state to be updated
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                // Assert the state
                XCTAssertEqual(recipeAPI.state, .fetched(.failure(.error("Invalid JSON"))))
                
                // Verify that the error is due to invalid JSON
                if case .fetched(.failure(.error(let errorMessage))) = recipeAPI.state {
                    XCTAssertEqual(errorMessage, "Invalid JSON")
                }
            }
        }
    }

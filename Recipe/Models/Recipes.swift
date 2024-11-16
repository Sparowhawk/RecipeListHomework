//
//  Recipes.swift
//  Recipe
//
//  Created by Dylan Nienberg on 11/14/24.
//

import SwiftUI

struct Response: Codable, Equatable {
    var recipes: [Recipe]
    
    static func == (lhs: Response, rhs: Response) -> Bool {
        return lhs.recipes == rhs.recipes
    }
}

struct Recipe: Hashable, Codable, Equatable, Identifiable {
    var id: UUID?
    let uuid: String?
    let name: String?
    let cuisine: String?
    let photo_url_large: String?
    let photo_url_small: String?
    let source_url: String?
    let youtube_url: String?
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try UUID(uuidString: container.decodeIfPresent(String.self, forKey: .uuid) ?? "")
        self.uuid = try container.decodeIfPresent(String.self, forKey: .uuid)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.cuisine = try container.decodeIfPresent(String.self, forKey: .cuisine)
        self.photo_url_large = try container.decodeIfPresent(String.self, forKey: .photo_url_large)
        self.photo_url_small = try container.decodeIfPresent(String.self, forKey: .photo_url_small)
        self.source_url = try container.decodeIfPresent(String.self, forKey: .source_url)
        self.youtube_url = try container.decodeIfPresent(String.self, forKey: .youtube_url)
    }
    
    init(id: UUID? = nil,
             uuid: String? = nil,
             name: String? = nil,
             cuisine: String? = nil,
             photo_url_large: String? = nil,
             photo_url_small: String? = nil,
             source_url: String? = nil,
             youtube_url: String? = nil) {
            self.id = id
            self.uuid = uuid
            self.name = name
            self.cuisine = cuisine
            self.photo_url_large = photo_url_large
            self.photo_url_small = photo_url_small
            self.source_url = source_url
            self.youtube_url = youtube_url
        }
    
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.id == rhs.id && lhs.name == rhs.name && lhs.cuisine == rhs.cuisine
    }
}

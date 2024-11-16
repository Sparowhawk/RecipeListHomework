//
//  ContentView.swift
//  Recipe
//
//  Created by Dylan Nienberg on 11/13/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @ObservedObject var recipeListFetcher = RecipeListFetcher()
    
    
    var stateContent: AnyView {
            switch recipeListFetcher.state {
            case .loading:
                return AnyView(Text("Loading"))
            case .fetched(let result):
                switch result {
                case .failure(let error):
                    return AnyView(
                        Text(error.localizedDescription)
                    )
                case .success(let response):
                    let malformedDataExists = response.recipes.contains(where: { Recipe in
                        return Recipe.cuisine == nil || Recipe.name == nil
                    })
                    
                    if (malformedDataExists) {
                        return AnyView(
                            Text("Data is malformed. Please refetch or pick a different api response")
                        )
                    }
                    if response.recipes.isEmpty {
                        return AnyView(
                            Text("Data is empty. Please refetch or pick a different api response")
                        )
                    }
                    return AnyView(
                        ForEach(response.recipes, id: \.id) { recipe in
                            RecipeItem(recipe: recipe)
                        }
                    )
                }
            }
        }
    
    var body: some View {
            NavigationView {
                VStack {
                    HStack {
                        Button("Working Data") {
                            recipeListFetcher.searchQuery = "recipes.json"
                        }.padding()
                        Button("Malformed Data") {
                            recipeListFetcher.searchQuery = "recipes-malformed.json"
                        }.padding()
                        Button("Empty Data") {
                            recipeListFetcher.searchQuery = "recipes-empty.json"
                        }.padding()
                    }
                    List {
                        stateContent
                    }.refreshable {
                        recipeListFetcher.update()
                    }
                    .navigationBarTitle(Text("Recipes"))
                }
            }
        }
}

#Preview {
    ContentView()
}

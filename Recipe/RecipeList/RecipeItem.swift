//
//  RecipeItem.swift
//  Recipe
//
//  Created by Dylan Nienberg on 11/14/24.
//

import SwiftUI

struct RecipeItem: View {
    var recipe: Recipe
    
    var body: some View {
        HStack {
            LoadableImageView(with: recipe.photo_url_small!).frame(width: 100, height: 100).cornerRadius(8.0).padding(8.0)
            VStack (alignment: .leading, content: {
                Spacer()
                Text(recipe.name!).scaledToFit()
                Text("Cuisine: " + recipe.cuisine!).scaledToFit()
                Spacer()
            })
            Spacer()
        }
    }
}

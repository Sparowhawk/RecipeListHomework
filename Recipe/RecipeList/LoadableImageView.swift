//
//  LoadableImageView.swift
//  Recipe
//
//  Created by Dylan Nienberg on 11/14/24.
//

import SwiftUI

struct LoadableImageView: View {
    @ObservedObject var imageAPI: ImageAPI
    init(with urlString: String) {
        imageAPI = ImageAPI(url: urlString)
    }
    
    var body: some View {
        if let image = UIImage(data: imageAPI.data) {
            return AnyView(
                Image(uiImage: image).resizable()
                    .aspectRatio(contentMode: .fit)
            )
        } else {
            return AnyView(
                ProgressView().onAppear(perform: {
                    imageAPI.fetchImageWithCacheCheck()
                })
            )
        }
    }
}

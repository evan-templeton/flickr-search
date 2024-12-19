//
//  DetailView.swift
//  CVSChallenge
//
//  Created by Evan Templeton on 11/19/24.
//

import SwiftUI

struct DetailView: View {
    
    let imageData: FlickrImage

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                AsyncImage(url: imageData.media.m) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                    } else {
                        Color.gray
                            .frame(height: 200)
                    }
                }
                Text("Title: \(imageData.title)")
                    .font(.headline)
                Text("Description: \(imageData.description)")
                Text("Author: \(imageData.author)")
                Text("Published: \(imageData.formattedDate)")
                    .font(.subheadline)
            }
            .padding()
        }
        .navigationTitle("Image Details")
    }
}

//
//  FlickrAPIService.swift
//  CVSChallenge
//
//  Created by Evan Templeton on 11/19/24.
//

import Foundation

protocol FlickrAPIServiceProtocol {
    func fetchImages(query: String) async throws -> [FlickrImage]
}

class FlickrAPIService: FlickrAPIServiceProtocol {
    func fetchImages(query: String) async throws -> [FlickrImage] {
        let formattedQuery = query.replacingOccurrences(of: " ", with: ",")
        let urlString = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&nojsoncallback=1&tags=\(formattedQuery)"
        
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let response = try JSONDecoder().decode(FlickrAPIResponse.self, from: data)
        
        return response.items
    }
}

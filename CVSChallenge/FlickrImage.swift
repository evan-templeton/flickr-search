//
//  FlickrImage.swift
//  CVSChallenge
//
//  Created by Evan Templeton on 11/19/24.
//

import Foundation

struct FlickrAPIResponse: Decodable {
    let items: [FlickrImage]
}

struct FlickrImageMediaResponse: Decodable, Hashable {
    let m: URL
}

struct FlickrImage: Identifiable, Decodable, Hashable {
    var id: String { return media.m.absoluteString }
    let title: String
    let media: FlickrImageMediaResponse
    let description: String
    let author: String
    let published: String
    
    var formattedDate: String {
        let dateFormatter = ISO8601DateFormatter()
        if let date = dateFormatter.date(from: published) {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        }
        return published
    }
}

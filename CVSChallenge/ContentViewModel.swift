//
//  ContentViewModel.swift
//  CVSChallenge
//
//  Created by Evan Templeton on 11/19/24.
//

import SwiftUI

class ContentViewModel: ObservableObject {
    @Published var images = [FlickrImage]()
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service: FlickrAPIServiceProtocol
    
    init(service: FlickrAPIServiceProtocol) {
        self.service = service
    }

    @MainActor
    func fetchImages(text: String) async {
        guard !text.isEmpty else { return }
        errorMessage = nil
        isLoading = true
        do {
            images = try await service.fetchImages(query: text)
            isLoading = false
        } catch {
            errorMessage = "Failed to fetch images: \(error)"
            isLoading = false
        }
    }
}

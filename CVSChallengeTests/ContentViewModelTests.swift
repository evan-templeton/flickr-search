//
//  ContentViewModelTests.swift
//  ContentViewModelTests
//
//  Created by Evan Templeton on 11/19/24.
//

import XCTest
@testable import CVSChallenge

final class ContentViewModelTests: XCTestCase {

    private var service = FlickrAPIServiceMock()
    private var viewModel: ContentViewModel!
    
    func testFetchImages_expectError() async {
        service.shouldThrowError = true
        viewModel = ContentViewModel(service: service)
        
        await viewModel.fetchImages(text: "test")
        await MainActor.run {
            XCTAssertNotNil(viewModel.errorMessage)
            XCTAssertFalse(viewModel.isLoading)
        }
        service.shouldThrowError = false
    }
    
    func testFetchImages_expectImages() async {
        viewModel = ContentViewModel(service: service)
        
        await viewModel.fetchImages(text: "test")
        await MainActor.run {
            XCTAssertFalse(viewModel.images.isEmpty)
            XCTAssertNil(viewModel.errorMessage)
            XCTAssertFalse(viewModel.isLoading)
        }
    }
    
    func testFetchImages_expectEmptyImages() async {
        service.shouldReturnEmptyImages = true
        viewModel = ContentViewModel(service: service)
        
        await viewModel.fetchImages(text: "test")
        await MainActor.run {
            XCTAssertTrue(viewModel.images.isEmpty)
            XCTAssertNil(viewModel.errorMessage)
            XCTAssertFalse(viewModel.isLoading)
        }
    }

}

final class FlickrAPIServiceMock: FlickrAPIServiceProtocol {
    
    var shouldThrowError = false
    var shouldReturnEmptyImages = false
    func fetchImages(query: String) async throws -> [FlickrImage] {
        if shouldThrowError {
            throw URLError(.badServerResponse)
        }
        if shouldReturnEmptyImages {
            return []
        } else {
            return [
                FlickrImage(
                    title: "title",
                    media: FlickrImageMediaResponse(m: URL(string: "https://google.com")!),
                    description: "description",
                    author: "author",
                    published: "published"
                )
            ]
        }
    }
}

//
//  ContentView.swift
//  CVSChallenge
//
//  Created by Evan Templeton on 11/19/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel(service: FlickrAPIService())
    @FocusState private var isInputActive: Bool
    
    @State private var selectedImage: FlickrImage?
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                searchField
                    .onChange(of: searchText) { oldValue, newValue in
                        if !newValue.isEmpty {
                            Task {
                                await viewModel.fetchImages(text: newValue)
                            }
                        }
                    }
                
                if viewModel.isLoading {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else if let errorMessage = viewModel.errorMessage {
                    Spacer()
                    Text(errorMessage)
                    Spacer()
                } else {
                    scrollView
                }
            }
            .padding(.horizontal)
            .padding(.top)
            .navigationTitle("Flickr Search")
            .sheet(item: $selectedImage) { image in
                DetailView(imageData: image)
            }
        }
    }
    
    private var searchField: some View {
        TextField("Search Flickr", text: $searchText)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .focused($isInputActive)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) { // Autolayout doesn't like this. Also doesn't like wrapping in an HStack.
                    Spacer()
                    Button("Done") {
                        isInputActive = false
                    }
                }
            }
    }
    
    private var scrollView: some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                ForEach(viewModel.images) { image in
                    Button {
                        isInputActive = false
                        selectedImage = image
                    } label: {
                        AsyncImage(url: image.media.m) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } else {
                                Color.gray
                            }
                        }
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

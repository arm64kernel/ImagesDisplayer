//
//  DescriptionListView.swift
//  ImagesDisplayer
//
//  Created by Vadim Ohapkin on 9.09.24.
//

import SwiftUI

private enum Constants {
    static let cornerRadius: CGFloat = 8.0
}

struct DescriptionListView: View {
    let imageDataArray: [ImagesData]
    
    @Binding var currentIndex: Int
    @Binding var searchQuery: String
    
    var body: some View {
        if let currentData = imageDataArray[safe: currentIndex] {
            LazyVStack {
                ForEach(filteredDescriptions(from: currentData.description), id: \.self) { description in
                    HStack(spacing: 12) {
                        imageView(from: currentData.image)
                        
                        VStack(alignment: .leading) {
                            descriptionView(from: description)
                        }
                        
                        Spacer()
                    }
                    .padding(8)
                    .background(Color.teal.opacity(0.10))
                    .cornerRadius(Constants.cornerRadius)
                }
            }
        } else {
            Text("No data available")
        }
    }
    
    private func imageView(from image: Image) -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 80, height: 60)
            .clipped()
            .cornerRadius(Constants.cornerRadius)
    }
    
    private func descriptionView(from description: [String: String]) -> some View {
        VStack(alignment: .leading) {
            ForEach(description.keys.sorted(), id: \.self) { key in
                if let value = description[key] {
                    Text(key)
                        .font(.headline)
                    
                    Text(value)
                        .font(.subheadline)
                }
            }
        }
    }
    
    private func filteredDescriptions(from descriptions: [[String: String]]) -> [[String: String]] {
        guard !searchQuery.isEmpty else {
            return descriptions
        }
        
        return descriptions.filter { description in
            description.values.contains { value in
                value.localizedCaseInsensitiveContains(searchQuery)
            }
        }
    }
}

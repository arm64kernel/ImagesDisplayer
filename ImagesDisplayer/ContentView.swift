//
//  ContentView.swift
//  ImagesDisplayer
//
//  Created by Vadim Ohapkin on 9.09.24.
//

import SwiftUI

struct ContentView: View {
    private let imageDataArray = ImagesData.loadAllImageData(fromDirectory: "SampleImages")
    
    @State private var currentIndex: Int = 0
    @State private var searchQuery: String = ""
    @State private var isShowingBottomSheet: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                CarouselView(
                    images: imageDataArray.map({ $0.image }),
                    currentIndex: $currentIndex
                )
                .frame(height: 280)
                
                LazyVStack(spacing: 20, pinnedViews: [.sectionHeaders]) {
                    Section(header: SearchInputField(searchText: $searchQuery)) {
                        DescriptionListView(
                            imageDataArray: imageDataArray,
                            currentIndex: $currentIndex,
                            searchQuery: $searchQuery
                        )
                        .frame(maxHeight: .infinity)
                    }
                }
                .padding(.horizontal, 15)
            }
        }
        .overlay(alignment: .bottomTrailing) {
            MysteryButton(onClick: showMysteryData)
                .offset(x: -24)
        }
        .sheet(isPresented: $isShowingBottomSheet) {
            MysteryBottomSheetView(statistics: calculateStatistics())
        }
    }
    
    private func showMysteryData() {
        isShowingBottomSheet = true
    }
    
    private func calculateStatistics() -> (itemCount: Int, topCharacters: [(character: Character, count: Int)]) {
        guard let currentPageData = imageDataArray[safe: currentIndex] else {
            return (0, [])
        }
        
        print("[XD]", currentPageData.description.count)
        
        let description: [[String: String]] = currentPageData.description
        let itemCount = description.count
        
        let concatenatedStrings = description.compactMap { $0.values.joined() }.joined()
        
        let characterCounts = concatenatedStrings.reduce(into: [:]) { counts, character in
            counts[character, default: 0] += 1
        }
        
        let topCharacters = characterCounts
            .sorted { $0.value > $1.value }
            .prefix(3)
            .map { ($0.key, $0.value) }
        
        return (itemCount, topCharacters)
    }
}

#Preview {
    ContentView()
}

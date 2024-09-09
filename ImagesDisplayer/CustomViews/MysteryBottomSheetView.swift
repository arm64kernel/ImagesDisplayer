//
//  MysteryBottomSheetView.swift
//  ImagesDisplayer
//
//  Created by Vadim Ohapkin on 9.09.24.
//

import SwiftUI

private enum Constants {
    static let sheetHeight: CGFloat = 300
}

struct MysteryBottomSheetView: View {
    let statistics: (itemCount: Int, topCharacters: [(character: Character, count: Int)])
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                
                Text("Useful Information")
                    .font(.title)
                    .bold()
                
                Spacer()
            }
            .padding()
            
            VStack(spacing: 24) {
                Text("This list consists of \(statistics.itemCount) item")
                    .font(.headline)
                
                VStack {
                    ForEach(statistics.topCharacters, id: \.character) { character, count in
                        HStack {
                            Text("The occurence of: '\(character)' is \(count)")

                            Spacer()
                        }
                    }
                }
            }
        }
        .padding()
        .presentationDetents([.height(Constants.sheetHeight)])
        .presentationDragIndicator(.visible)
    }
}

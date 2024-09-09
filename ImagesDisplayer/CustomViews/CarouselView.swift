//
//  CarouselView.swift
//  ImagesDisplayer
//
//  Created by Vadim Ohapkin on 9.09.24.
//

import SwiftUI

private enum Constants {
    static let cornerRadius: CGFloat = 8.0
}

struct CarouselView: View {
    let images: [Image]
    
    @Binding var currentIndex: Int
        
    var body: some View {
        VStack {
            GeometryReader { geo in
                TabView(selection: $currentIndex) {
                    ForEach(0..<images.count, id: \.self) { index in
                        images[index]
                            .resizable()
                            .frame(maxWidth: geo.size.width, maxHeight: .infinity)
                            .tag(index)
                            .contentShape(Rectangle())
                            .clipped()
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .cornerRadius(Constants.cornerRadius)
                .clipped()
            }
            
            HStack {
                ForEach(0..<images.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color.black : Color.gray)
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.top, 10)
        }
        .padding()
    }
}

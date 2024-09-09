//
//  MysteryButton.swift
//  ImagesDisplayer
//
//  Created by Vadim Ohapkin on 9.09.24.
//

import SwiftUI

private enum Constants {
    static let size: CGFloat = 28
    static let imageName = "questionmark.diamond"
}

struct MysteryButton: View {
    var onClick: (() -> Void)?
    
    var body: some View {
        Button(action: {
            onClick?()
        }, label: {
            Image(systemName: Constants.imageName)
                .resizable()
                .frame(width: Constants.size, height: Constants.size)
                .tint(.white)
                .padding(18)
                .background(Color.blue)
                .cornerRadius(.greatestFiniteMagnitude)
                
        })
        .frame(width: 64, height: 64)
    }
}

#Preview {
    MysteryButton()
}

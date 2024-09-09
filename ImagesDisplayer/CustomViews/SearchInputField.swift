//
//  SearchInputField.swift
//  ImagesDisplayer
//
//  Created by Vadim Ohapkin on 9.09.24.
//

import SwiftUI

private enum Constants {
    static let leftIconName = "magnifyingglass"
}

struct SearchInputField: View {
    @Binding var searchText: String
    @FocusState private var isFocused: Bool
    
    var body: some View {
        HStack {
            Image(systemName: Constants.leftIconName)
                .foregroundColor(.gray)
                .padding(.horizontal, 5)
            
            Spacer()
            
            TextField("Search", text: $searchText)
                .focused($isFocused)
                .textFieldStyle(.plain)
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .cornerRadius(8)
        .onTapGesture {
            isFocused = true
        }
    }
}

#Preview {
    SearchInputField(searchText: .constant(""))
}

//
//  ImageData.swift
//  ImagesDisplayer
//
//  Created by Vadim Ohapkin on 9.09.24.
//

import UIKit

class ImageData {
    let id: String
    let image: UIImage
    let description: [[String: String]]
    
    init(image: UIImage, description: [[String: String]]) {
        self.id = UUID().uuidString
        self.image = image
        self.description = description
    }
}


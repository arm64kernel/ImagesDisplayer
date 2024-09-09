//
//  Image+LoadAllImages.swift
//  ImagesDisplayer
//
//  Created by Vadim Ohapkin on 9.09.24.
//

import SwiftUI

struct ImagesData: Identifiable {
    let id = UUID().uuidString
    
    let image: Image
    let description: [[String: String]]
}

extension ImagesData {
    static func loadAllImageData(fromDirectory directory: String, fileExtension: String = "jpg") -> [ImagesData] {
        guard let directoryPath = Bundle.main.path(forResource: directory, ofType: nil) else {
            print("Directory \(directory) not found.")
            return []
        }

        let fileManager = FileManager.default
        let url = URL(fileURLWithPath: directoryPath)
        
        var imagesData: [ImagesData] = []
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            
            for fileURL in fileURLs {
                // Check if the file has the correct extension
                if fileURL.pathExtension == fileExtension {
                    let imageName = fileURL.deletingPathExtension().lastPathComponent
                    
                    if let uiImage = UIImage(contentsOfFile: fileURL.path) {
                        let randomDescription = generateRandomDescription()
                        
                        let newData = ImagesData(
                            image: Image(uiImage: uiImage),
                            description: randomDescription
                        )
                        
                        imagesData.append(newData)
                    } else {
                        print("Image \(imageName) could not be loaded.")
                    }
                }
            }
        } catch {
            print("Error while enumerating files: \(error.localizedDescription)")
        }
                
        return imagesData
    }

    /// Generates random descriptive data for each image.
    ///
    /// - Returns: An array of dictionaries where each dictionary is a key-value pair of random data.
    static func generateRandomDescription() -> [[String: String]] {
        let keys = ["Forest", "Jungle", "Ocean", "Desert", "Mountain", "River", "Valley", "City", "Village", "Countryside"]
        let values = [
            "serene", "tranquil", "idyllic", "picturesque", "stunning", "breathtaking", "pristine",
            "verdant", "lush", "majestic", "untamed", "mystical", "captivating", "scenic",
            "dramatic", "ethereal", "vibrant", "enchanting", "expansive", "isolated", "remote",
            "secluded", "rugged", "ancient", "unspoiled", "quaint", "charming", "sophisticated",
            "timeless", "alluring", "immense", "mysterious", "peaceful"
        ]
        
        var randomDescription: [[String: String]] = []
        
        let numberOfEntries = Int.random(in: 2...4)  // Random between 2 and 4 entries
        
        for _ in 0..<numberOfEntries {
            guard let randomKey = keys.randomElement() else { continue }
            let generatedValue = values.shuffled().prefix(3).joined(separator: " ")  // Pick 3 random words
            randomDescription.append([randomKey: generatedValue])
        }
        
        return randomDescription
    }
}

//
//  ImageLoader.swift
//  Photo-Temperature
//
//  Created by Auliya Michelle Adhana on 04/03/25.
//

import SwiftUI
import PhotosUI

class ImageLoader {
    /// Loads and validates an image from a PhotosPickerItem
    /// - Parameters:
    ///   - item: The PhotosPickerItem to load
    ///   - completion: Completion handler called with the result
    static func loadImage(from item: PhotosPickerItem, completion: @escaping (Result<UIImage, ImageError>) -> Void) {
        Task.detached {
            // Try to load the image data
            guard let data = try? await item.loadTransferable(type: Data.self),
                  let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    completion(.failure(.loadFailed))
                }
                return
            }

            // Verify the image is JPEG format
            guard let uti = item.supportedContentTypes.first?.identifier,
                  uti.lowercased().contains("jpeg") else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidFormat))
                }
                return
            }

            // Return the successfully loaded image
            DispatchQueue.main.async {
                completion(.success(image))
            }
        }
    }

    /// Possible errors that can occur during image loading
    enum ImageError: Error {
        case loadFailed
        case invalidFormat
    }
}

extension ImageLoader.ImageError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .loadFailed:
            return "Failed to load image. Please try again."
        case .invalidFormat:
            return "Invalid format. Only JPEG images are supported."
        }
    }
}

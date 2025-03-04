//
//  ImageSaver.swift
//  Photo-Temperature
//
//  Created by Auliya Michelle Adhana on 03/03/25.
//

import UIKit

class ImageSaver: NSObject {
    /// Callback closure that will be called when saving completes
    var onComplete: ((Bool, String) -> Void)?

    /// Writes the given UIImage to the photo album
        /// - Parameter image: The image to save
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    /// Called when the save operation completes
       /// - Parameters:
       ///   - image: The image that was saved
       ///   - error: Any error that occurred during saving
       ///   - contextInfo: Additional context information
    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
                  onComplete?(false, error.localizedDescription)
              } else {
                  onComplete?(true, "Your photo has been saved successfully!")
              }
    }
}

//
//  ImageSaver.swift
//  Photo-Temperature
//
//  Created by Auliya Michelle Adhana on 03/03/25.
//

import UIKit

class ImageSaver: NSObject {
    var onComplete: ((Bool, String) -> Void)?
    
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
                  onComplete?(false, error.localizedDescription)
              } else {
                  onComplete?(true, "Your photo has been saved successfully!")
              }
    }
}

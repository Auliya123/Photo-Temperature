//
//  PhotoEditoeVM.swift
//  Photo-Temperature
//
//  Created by Auliya Michelle Adhana on 04/03/25.
//

import SwiftUI
import Photos

class PhotoEditorVM: ObservableObject {
    let originalImage: UIImage

    @Published var temperature: Float = 0
    @Published  var debounceWorkItem: DispatchWorkItem?
    @Published  var editedImage: UIImage
    @Published  var showAlert: Bool = false
    @Published  var alertTitle: String = ""
    @Published  var alertMessage: String = ""

    init(image: UIImage) {
        self.originalImage = image
        self.editedImage = image
    }

    func processImage() {
        debounceWorkItem?.cancel()
        let workItem = DispatchWorkItem { [weak self] in
            guard let self else { return }
            let processedImage = OpenCVWrapper.adjustTemperature(originalImage, withValue: temperature)

            DispatchQueue.main.async {
                self.editedImage = processedImage
            }
        }

        debounceWorkItem = workItem
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.12, execute: workItem)

    }

    func saveImage(_ image: UIImage) {
        let status = PHPhotoLibrary.authorizationStatus()

        switch status {
        case .authorized, .limited:
            // Permission granted → Save image
            proceedToSave(image)

        case .denied, .restricted:
            // Permission denied → Show alert to go to Settings
            showAlert = true
            alertTitle = "Photo Access Denied"
            alertMessage = "Please allow access in Settings to save photos."

        case .notDetermined:
            // First-time request → Ask for permission
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    if newStatus == .authorized || newStatus == .limited {
                        proceedToSave(image)
                    } else {
                        showAlert = true
                        alertTitle = "Photo Access Denied"
                        alertMessage = "Please allow access in Settings to save photos."
                    }
                }
            }

        default:
            break
        }
    }

    func proceedToSave(_ image: UIImage) {
        let imageSaver = ImageSaver()
        imageSaver.onComplete = { success, message in
            DispatchQueue.main.async {  [weak self] in
                guard let self else { return }
                alertTitle = success ? "Saved" : "Error"
                alertMessage = message
                showAlert = true
            }
        }
        imageSaver.writeToPhotoAlbum(image: image)
    }
}

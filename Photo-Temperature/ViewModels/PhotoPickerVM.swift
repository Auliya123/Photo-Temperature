//
//  PhotoPickerVM.swift
//  Photo-Temperature
//
//  Created by Auliya Michelle Adhana on 04/03/25.
//

import SwiftUI
import PhotosUI

class PhotoPickerVM : ObservableObject {

    @Published var selectedItem: PhotosPickerItem? = nil
    @Published  var selectedImage: UIImage? = nil
    @Published var navigateToEditor = false
    @Published  var showAlert = false
    @Published  var alertMessage: String? = ""

    func loadImage(){
        guard let selectedItem = selectedItem else { return }
        ImageLoader.loadImage(from: selectedItem ) { result in
            self.selectedItem = nil
            switch result {
            case .success(let image):
                self.selectedImage = image
            case .failure(let failure):
                self.selectedImage = nil
                self.showAlert = true
                self.alertMessage = failure.errorDescription

            }
        }
    }
}

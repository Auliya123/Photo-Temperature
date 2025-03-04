//
//  PhotoPickerView.swift
//  Photo-Temperature
//
//  Created by Auliya Michelle Adhana on 04/03/25.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @StateObject private var viewModel = PhotoPickerVM()

    var body: some View {
        NavigationStack {
            ZStack{
                Color.white.ignoresSafeArea()
                VStack {
                    Text("Photo Temperature")
                        .foregroundColor(.black)
                        .font(.largeTitle)
                        .bold()

                    PhotosPicker(selection: $viewModel.selectedItem, matching: .images) {
                        PhotoSelectionAreaView()
                    }.onChange(of: viewModel.selectedItem) {
                        viewModel.loadImage()
                    }
                }
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text("Error"), message: Text(viewModel.alertMessage ?? ""), dismissButton: .default(Text("OK")))
            }
            .navigationDestination(isPresented: Binding(
                get: { viewModel.selectedImage != nil },
                set: { if !$0 { viewModel.selectedImage = nil } }
            )) {
                if let image = viewModel.selectedImage {
                    PhotoEditorView(image: image)
                }
            }
        }
    }
}

#Preview {
    PhotoPickerView()
}

//
//  PhotoEditorView.swift
//  Photo-Temperature
//
//  Created by Auliya Michelle Adhana on 04/03/25.
//

import SwiftUI
import Photos

struct PhotoEditorView: View {

    @StateObject var viewModel: PhotoEditorVM
    @Environment(\.dismiss) var dismiss

    init(image: UIImage) {
        _viewModel = StateObject(wrappedValue: PhotoEditorVM(image: image))
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(edges: .all)

            VStack {
                // Image display area
                PhotoEditorImageView(image: viewModel.editedImage)

                // Temperature control section
                TemperatureControlView(
                    temperature: $viewModel.temperature,
                    onTemperatureChange: viewModel.processImage
                )

            }
            .padding()
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonView(dismiss: dismiss)
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button("Export") {
                    // Save the original image if it's unmodified
                    viewModel.saveImage(viewModel.editedImage)
                }.tint(.white)
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text(viewModel.alertTitle), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK").foregroundStyle(.blue)))
        }

    }


}

//
//  PhotoEditorView.swift
//  Photo-Temperature
//
//  Created by Auliya Michelle Adhana on 04/03/25.
//

import SwiftUI
import Photos

struct PhotoEditorView: View {
    @Environment(\.dismiss) var dismiss

    let image: UIImage
    @State private var temperature: Float = 0
    @State private var debounceWorkItem: DispatchWorkItem?
    @State private var editedImage: UIImage?
    @State private var showAlert: Bool = false
    @State private var alertTitle: String = ""
    @State private var alertMessage: String = ""


    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(edges: .all)

            VStack {
                Image(uiImage: editedImage ?? image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 500)

                HStack{
                    Text("Temp").foregroundStyle(.white)
                    Spacer()
                    Text("\(Int(temperature))").foregroundStyle(.white)
                }.padding(.horizontal, 20).padding(.top, 16)

                Slider(value: $temperature, in: -100...100)
                    .tint(.orange)
                    .background(Color.black)
                    .padding(.horizontal, 20)
                    .onChange(of: temperature){
                        processImage()
                    }

            }
            .padding()
        }
        .onAppear(){
            editedImage = image
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button("Export") {
                    guard let editedImage = editedImage else { return }
                    saveImage(editedImage)
                }.tint(.white)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK").foregroundStyle(.blue)))
        }

    }

    private func processImage() {
        debounceWorkItem?.cancel()
        let workItem = DispatchWorkItem {

            let processedImage = OpenCVWrapper.adjustTemperature(image, withValue: temperature)

            DispatchQueue.main.async {
                self.editedImage = processedImage
            }
        }

        debounceWorkItem = workItem
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.12, execute: workItem)

    }

    private func saveImage(_ image: UIImage) {
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
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        self.proceedToSave(image)
                    } else {
                        self.showAlert = true
                        alertTitle = "Photo Access Denied"
                        alertMessage = "Please allow access in Settings to save photos."
                    }
                }
            }

        default:
            break
        }
    }
    
    private func proceedToSave(_ image: UIImage) {
        let imageSaver = ImageSaver()
        imageSaver.onComplete = { success, message in
            DispatchQueue.main.async {
                alertTitle = success ? "Saved" : "Error"
                alertMessage = message
                showAlert = true
            }
        }
        imageSaver.writeToPhotoAlbum(image: image)
    }
}

//
//  ContentView.swift
//  Photo-Temperature
//
//  Created by Auliya Michelle Adhana on 02/03/25.
//

import SwiftUI
import PhotosUI
import Photos

struct ContentView: View {

    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var showAlert = false
    @State private var temperature: Float = 0.0
    @State private var editedImage: UIImage?
    @State private var debounceWorkItem: DispatchWorkItem?
    @State private var alertTitle: String = "Error"
    @State private var alertMessage: String = "There is something error"

    var body: some View {
        ZStack{
            // Set Background Color
            Color.white.ignoresSafeArea(edges: .all)

            GeometryReader { geometry in
                VStack(){
                    Button("Export") {
                        if let editedImage = editedImage {
                            saveImage(editedImage)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding(.trailing, 20)

                VStack{
                    Text("Change Your Photo Tone")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.black)

                    ZStack {
                        if let image = editedImage {
                            VStack{
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: geometry.size.width - 40, height: 520)
                                    .frame(maxWidth: .infinity)

                                Text("\(Int(temperature))")
                                    .font(.body)
                                    .padding(6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.gray, lineWidth: 1)
                                            .background(Color.gray.opacity(0.5))
                                    )
                                    .foregroundColor(.black)
                                Slider(value: $temperature, in: -100...100, step: 1) {
                                    Text("Temperature")
                                }
                                .padding()
                                .onChange(of: temperature){
                                    processImage()
                                }
                            }

                        } else {
                            RoundedRectangle(cornerRadius: 12)
                                .strokeBorder(Color.blue, style: StrokeStyle(lineWidth: 2, dash: [5]))
                                .background(Color.blue.opacity(0.1))
                                .frame(width: geometry.size.width - 40, height: 520)
                                .frame(maxWidth: .infinity)

                            VStack {
                                PhotosPicker(selection: $selectedItem, matching: .images) {
                                    Text("Choose Foto")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.blue)
                                        .cornerRadius(8)
                                }
                                .onChange(of: selectedItem) {
                                    loadImage()
                                }

                                Text("Only JPEG photos are supported")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                    .padding(.top, 5)
                            }
                        }
                    }


                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical, 20)
                .alert(isPresented: $showAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }


            }
        }
    }

    private func loadImage() {
        Task.detached {
            if let data = try? await selectedItem?.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {

                if let uti = await selectedItem?.supportedContentTypes.first?.identifier,
                   uti.lowercased().contains("jpeg") {
                    DispatchQueue.main.async {
                        self.selectedImage = image
                        self.editedImage = image
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showAlert = true
                        self.alertTitle = "Format not supported"
                        self.alertMessage = "Please select JPEG photo"
                        self.selectedImage = nil
                        self.editedImage = nil
                    }
                }
            }
        }


    }

    private func processImage() {
        debounceWorkItem?.cancel()
        let workItem = DispatchWorkItem {
            guard var selectedImage = selectedImage else { return }
            let processedImage = OpenCVWrapper.adjustTemperature(selectedImage, withValue: temperature)

            DispatchQueue.main.async {
                self.editedImage = processedImage
            }
        }

        debounceWorkItem = workItem
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 0.1, execute: workItem)
    }

    private func saveImage(_ image: UIImage) {
        let status = PHPhotoLibrary.authorizationStatus()

        switch status {
        case .authorized, .limited:
            // Permission granted → Save image
            proceedToSave(image)

        case .denied, .restricted:
            // Permission denied → Show alert to go to Settings
            alertTitle = "Photo Access Denied"
            alertMessage = "Please allow access in Settings to save photos."
            showAlert = true

        case .notDetermined:
            // First-time request → Ask for permission
            PHPhotoLibrary.requestAuthorization { newStatus in
                DispatchQueue.main.async {
                    if newStatus == .authorized || newStatus == .limited {
                        self.proceedToSave(image)
                    } else {
                        self.alertTitle = "Photo Access Denied"
                        self.alertMessage = "Please allow access in Settings to save photos."
                        self.showAlert = true
                    }
                }
            }

        @unknown default:
            break
        }
    }

    private func proceedToSave(_ image: UIImage) {
        let imageSaver = ImageSaver()
        imageSaver.onComplete = { success, message in
            DispatchQueue.main.async {
                alertTitle = success ? "Saved!" : "Error"
                alertMessage = message
                showAlert = true
            }
        }
        imageSaver.writeToPhotoAlbum(image: image)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


#Preview {
    ContentView()
}

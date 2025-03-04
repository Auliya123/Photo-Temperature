//
//  PhotoPickerView.swift
//  Photo-Temperature
//
//  Created by Auliya Michelle Adhana on 04/03/25.
//

import SwiftUI
import PhotosUI

struct PhotoPickerView: View {
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var navigateToEditor = false
    @State private var showAlert = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color.blue, style: StrokeStyle(lineWidth: 2, dash: [5]))
                            .fill(Color.blue.opacity(0.2))
                            .frame(maxWidth: .infinity, maxHeight: 600)
                        
                        VStack {
                            
                            Text("Pilih Foto").padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                            
                            
                            
                            Text("Only JPEG files are supported")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }.padding()
                }.onChange(of: selectedItem) {
                    loadImage()
                }
                
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Format not supported"), message: Text("Please select JPEG photo"), dismissButton: .default(Text("OK")))
            }
            .navigationTitle("Edit Temperatur Foto")
            .navigationDestination(isPresented: Binding(
                get: { selectedImage != nil },
                set: { if !$0 { selectedImage = nil } }
            )) {
                if let image = selectedImage {
                    PhotoEditorView(image: image)
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
                        self.selectedItem = nil
                    }
                } else {
                    DispatchQueue.main.async {
                        self.showAlert = true
                        self.selectedImage = nil
                        self.selectedItem = nil
                    }
                }
            }
        }
    }
}

#Preview {
    PhotoPickerView()
}

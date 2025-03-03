//
//  ContentView.swift
//  Photo-Temperature
//
//  Created by Auliya Michelle Adhana on 02/03/25.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var showAlert = false
    @State private var temperature: Float = 0.0
    @State private var editedImage: UIImage?
    @State private var debounceWorkItem: DispatchWorkItem?
    
    var body: some View {
        ZStack{
            // Set Background Color
            Color.white.ignoresSafeArea(edges: .all)
            
            GeometryReader { geometry in
                VStack(){
                    Button("Export") {
                        print("Button tapped!")
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
                    Alert(title: Text("Format not supported"), message: Text("Please select JPEG photo"), dismissButton: .default(Text("OK")))
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


#Preview {
    ContentView()
}

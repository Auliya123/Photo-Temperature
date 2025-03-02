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
                        if let image = selectedImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: geometry.size.width - 40, height: 520)
                                .frame(maxWidth: .infinity)

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
        Task {
            if let data = try? await selectedItem?.loadTransferable(type: Data.self),
               let image = UIImage(data: data) {

                if let uti = selectedItem?.supportedContentTypes.first?.identifier,
                   uti.lowercased().contains("jpeg") {
                    selectedImage = image
                } else {
                    showAlert = true
                    selectedImage = nil
                }
            }
        }
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

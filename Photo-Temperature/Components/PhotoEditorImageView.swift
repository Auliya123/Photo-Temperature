//
//  PhotoEditorImageView.swift
//  Photo-Temperature
//
//  Created by Auliya Michelle Adhana on 04/03/25.
//
import SwiftUI

struct PhotoEditorImageView: View {
    let image: UIImage

    var body: some View {
        Image(uiImage: image)
            .resizable()
            .scaledToFit()
            .frame(maxHeight: 500)
    }
}

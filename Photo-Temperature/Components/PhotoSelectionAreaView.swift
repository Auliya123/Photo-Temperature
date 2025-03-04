//
//  PhotoSelectionAreaView.swift
//  Photo-Temperature
//
//  Created by Auliya Michelle Adhana on 04/03/25.
//

import SwiftUI

struct PhotoSelectionAreaView: View {
    var body: some View {
        ZStack {
            // Dashed Outline Rectangle
            RoundedRectangle(cornerRadius: 10)
                .strokeBorder(Color("DarkBlue"), style: StrokeStyle(lineWidth: 2, dash: [5]))
                .background(Color("LightBlue"))
                .frame(maxWidth: .infinity, maxHeight: 600)

            VStack {
                // Selection Button
                Text("Choose Photo").padding()
                    .background(Color("DarkBlue"))
                    .foregroundColor(.white)
                    .cornerRadius(10)

                // Format Information
                Text("Only JPEG files are supported")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }.padding()
    }
}

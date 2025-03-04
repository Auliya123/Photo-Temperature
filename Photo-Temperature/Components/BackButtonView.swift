//
//  BackButton.swift
//  Photo-Temperature
//
//  Created by Auliya Michelle Adhana on 04/03/25.
//

import SwiftUI

struct BackButtonView: View {
    let dismiss: DismissAction

    var body: some View {
        Button(action: {
            dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
        }
    }
}

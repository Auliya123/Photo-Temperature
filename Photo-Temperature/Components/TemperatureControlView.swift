//
//  TemperatureControlView.swift
//  Photo-Temperature
//
//  Created by Auliya Michelle Adhana on 04/03/25.
//

import SwiftUI

struct TemperatureControlView: View {
    /// Binding to the temperature value
    @Binding var temperature: Float

    /// Callback function when temperature changes
    var onTemperatureChange: () -> Void

    var body: some View {
        VStack {
            // Temperature label and value
            HStack {
                Text("Temp").foregroundStyle(.white)
                Spacer()
                Text("\(Int(temperature))").foregroundStyle(.white)
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)

            // Temperature adjustment slider
            Slider(value: $temperature, in: -100...100)
                .tint(.orange)
                .background(Color.black)
                .padding(.horizontal, 20)
                .onChange(of: temperature) {
                    onTemperatureChange()
                }
        }
    }
}

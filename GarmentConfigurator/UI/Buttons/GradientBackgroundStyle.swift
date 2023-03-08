//
//  GradientBackgroundStyle.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 27/02/23.
//

import SwiftUI

struct GradientBackgroundStyle: ButtonStyle {
    let startColor: Color
    let endColor: Color

    @Environment(\.isEnabled) private var isEnabled: Bool

    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
//            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(gradient: Gradient(stops: [
                            Gradient.Stop(color: startColor, location: 0.1),
                            Gradient.Stop(color: endColor, location: 0.7),
                        ]), startPoint: .top, endPoint: .bottom)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white, lineWidth: 2)
                    )
            )
            .foregroundColor(.white)
            .font(.system(size: 16, weight: .bold))
        
        //            .background(isEnabled
        //                        ? LinearGradient(gradient: Gradient(colors: [startColor, endColor]),
        //                                         startPoint: .leading, endPoint: .trailing)
        //                        : LinearGradient(colors: [Color(Asset.Colors.accentColor.color)],
        //                                         startPoint: .bottom, endPoint: .top)
        //        )
        
    }
}

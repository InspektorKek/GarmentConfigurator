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
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
            .background(isEnabled
                        ? LinearGradient(gradient: Gradient(colors: [startColor, endColor]),
                                         startPoint: .leading, endPoint: .trailing)
                        : LinearGradient(colors: [Color(Asset.Colors.accentColor.color)],
                                         startPoint: .bottom, endPoint: .top))
            .cornerRadius(15, antialiased: true)
    }
}

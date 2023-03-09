//
//  GradientButtonOptions.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 09/03/23.
//

import UIKit

struct GradientButtonOptions {
    let borderWidth: CGFloat?
    let colors: [UIColor]
    let cornerRadius: CGFloat?
    let direction: CALayer.GradientDirection?
    let gradientState: GradientButtonState?
    
    init(direction: CALayer.GradientDirection? = nil, borderWidth: CGFloat? = nil, colors: [UIColor] = [], cornerRadius: CGFloat? = nil, gradientState: GradientButtonState? = nil) {
        self.direction = direction
        self.borderWidth = borderWidth
        self.colors = colors
        self.cornerRadius = cornerRadius
        self.gradientState = gradientState
    }
}

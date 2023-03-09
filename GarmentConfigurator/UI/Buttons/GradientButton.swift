//
//  GradientButton.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 09/03/23.
//

import UIKit

enum GradientButtonState {
    case border
    case fill
}

class GradientButton: UIButton {
    // MARK: - Private Properties
    private var gradientBorderWidth: CGFloat = 1
    private var colors = [Asset.Colors.Gradients.first.color, Asset.Colors.Gradients.second.color]
    private var cornerRadius: CGFloat = 16
    private var gradientDirection: CALayer.GradientDirection = .horizontal
    
    private var gradientBorderLayer: CAGradientLayer?
    private var gradientLayer: CAGradientLayer?
    
    private var gradientState: GradientButtonState = .border
    
    // MARK: - Lifecycle
    override func layoutSubviews() {
        super.layoutSubviews()
        updateState()
    }
    
    // MARK: - Public Methods
    func configure(with options: GradientButtonOptions) {
        gradientBorderWidth = options.borderWidth ?? gradientBorderWidth
        colors = options.colors.isEmpty ? colors : options.colors
        cornerRadius = options.cornerRadius ?? cornerRadius
        gradientDirection = options.direction ?? gradientDirection
        gradientState = options.gradientState ?? gradientState
        updateState()
    }
}

// MARK: - Helpers
private extension GradientButton {
    func updateState() {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = cornerRadius != 0
        removeAllGradientLayers()
        
//        switch gradientState {
//        case .border:
        gradientBorderLayer = layer.addGradientBorder(direction: gradientDirection, lineWidth: gradientBorderWidth, colors: [.white, .white])
//        case .fill:
            gradientLayer = layer.addFillGradient(direction: gradientDirection, colors: colors)
//        }
    }
    
    func removeAllGradientLayers() {
        gradientBorderLayer?.removeFromSuperlayer()
        gradientBorderLayer = nil
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = nil
    }
}


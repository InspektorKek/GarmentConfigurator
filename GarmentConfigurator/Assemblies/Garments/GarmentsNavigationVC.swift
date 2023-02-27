//
//  GarmentsNavigationVC.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 27/02/23.
//

import UIKit

final class GarmentsNavigationVC: NavigationVC {

    weak var delegate: ConfigurationContainerDelegate?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.accentColor.color
        label.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        label.text = "Garments"
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
    }

    private func setupLayout() {
        controlsContainer.addSubviews([
            titleLabel
        ])

        titleLabel.snp.makeConstraints { make in
            make.topMargin.bottom.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalTo(16)
            make.height.equalTo(44)
        }
    }
}

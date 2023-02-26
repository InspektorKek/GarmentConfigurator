//
//  BackButtonAndTitleNavigationVC.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 24/02/23.
//

import UIKit

class BackButtonAndTitleNavigationVC: BackButtonNavigationVC {
    private let navigationTitle: String

    init(navigationTitle: String, backButtonDelegate: BackNavigator) {
        self.navigationTitle = navigationTitle
        super.init(backButtonDelegate: backButtonDelegate)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textAlignment = .center
        label.textColor = Asset.Colors.labelsPrimary.color
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        controlsContainer.addSubviews([titleLabel])
        titleLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(backButton.snp.trailing).offset(8)
            make.centerY.centerX.equalToSuperview()
        }

        titleLabel.text = navigationTitle
    }
}

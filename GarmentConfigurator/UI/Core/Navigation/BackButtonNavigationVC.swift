//
//  BackButtonNavigationVC.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 24/02/23.
//

import UIKit

class BackButtonNavigationVC: NavigationVC {
    private weak var backButtonDelegate: BackNavigator?

    init(backButtonDelegate: BackNavigator) {
        self.backButtonDelegate = backButtonDelegate
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let heighRule = UIView()

    lazy var backButton: UIButton = {
        var config = UIButton.Configuration.borderless()
        let symbolConfiguration = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 15, weight: .medium))
        let image = UIImage(systemName: "chevron.backward",
                            withConfiguration: symbolConfiguration)?.withRenderingMode(.alwaysTemplate)
        config.image = image
        config.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
        let button = UIButton(configuration: config)
        button.tintColor = Asset.Colors.labelsPrimary.color
        button.addAction { [weak self] in
            self?.backButtonDelegate?.back()
        }
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        controlsContainer.addSubviews([heighRule, backButton])
        heighRule.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(44.0).priority(.high)
        }
        backButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
        }
        backButton.setContentCompressionResistancePriority(.required, for: .horizontal)
        backButton.setContentHuggingPriority(.required, for: .horizontal)
    }
}

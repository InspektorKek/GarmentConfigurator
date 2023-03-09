//
//  GarmentsNavigationVC.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 27/02/23.
//

import UIKit

final class GarmentsNavigationVC: NavigationVC {

    weak var delegate: GarmentsContainerDelegate?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.accentColor.color
        label.font = UIFont.systemFont(ofSize: 34, weight: .medium)
        label.text = "Garments"
        return label
    }()
    
    private let addButton: UIButton = {
        let button = GradientButton()
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        button.setTitle(L10n.coreButtonAdd, for: .normal)
        button.setTitleColor(Asset.Colors.labelsPrimary.color, for: .normal)
        let options = GradientButtonOptions(direction: .vertical, cornerRadius: 16)
        button.configure(with: options)
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 24, bottom: 5, right: 24)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()
        
        addButton.addAction { [weak self] in
            self?.delegate?.addActionTapped()
        }
    }

    private func setupLayout() {
        controlsContainer.addSubviews([
            titleLabel, addButton
        ])

        titleLabel.snp.makeConstraints { make in
            make.topMargin.bottom.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.equalTo(16)
            make.height.equalTo(44)
        }
        
        addButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-20)
            make.centerY.equalToSuperview()
            make.height.equalTo(40)
        }
    }
}

//
//  DescriptionViewController.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 09.04.2023.
//

import UIKit

class DescriptionViewController: UIViewController {
    
    let stringURL: String
    
    init(stringURL: String) {
        self.stringURL = stringURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let descriptionView = WikiImageView(frame: .zero)

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 1
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var wikiButton: UIButton = {
        var configuration = UIButton.Configuration.tinted()
        configuration.title = "Wikipedia"
        configuration.image = UIImage(named: "wikiLogo")
        configuration.imagePadding = 4
        configuration.baseBackgroundColor = .systemCyan
        configuration.baseForegroundColor = .systemCyan

        let button = UIButton(configuration: configuration)
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        var configuration = UIButton.Configuration.tinted()
        configuration.image = UIImage(systemName: "chevron.backward.circle")
        configuration.imagePadding = 4
        configuration.baseBackgroundColor = .systemRed
        configuration.baseForegroundColor = .systemRed

        
        let button = UIButton(configuration: configuration, primaryAction: UIAction { _ in
            self.dismiss(animated: true)
        })
        return button
    }()
    
    private let container: UIStackView = {
        let container = UIStackView()
        container.axis = .vertical
        container.distribution = .fillEqually
        return container
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addAllSubviews(descriptionView, descriptionLabel, container)
        container.addArrangedSubview(wikiButton)
        container.addArrangedSubview(cancelButton)
        descriptionLabel.backgroundColor = .clear
        
        descriptionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(view.snp.height).dividedBy(2.5)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(descriptionView.snp.bottom)
            make.height.equalTo(view.snp.height).dividedBy(3)
        }
        
        container.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
        }
    }
}

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
        label.textAlignment = .center
        return label
    }()
    
    private lazy var wikiButton: UIButton = {
        var configuration = UIButton.Configuration.tinted()
        var container = AttributeContainer()

        container.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        configuration.attributedTitle = AttributedString("Wikipedia", attributes: container)
        configuration.image = UIImage(named: "wikiLogo")?.resized(to: CGSize(width: 30, height: 30))
        configuration.buttonSize = .large
        configuration.imagePadding = 10
        configuration.baseBackgroundColor = .systemRed
        configuration.baseForegroundColor = .systemRed

        let button = UIButton(configuration: configuration)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addAllSubviews(descriptionView, descriptionLabel, wikiButton)
        descriptionLabel.backgroundColor = .clear
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: UIAction { _ in
            self.dismiss(animated: true)
        })
        
        // MARK: REDO - delete after debugging:
        descriptionLabel.text = """
        Essentially, a Terms and Conditions agreement is a contract between your business and the user of your website or app - whether they are an individual or a business. You may see Terms and Conditions agreements referred to as Terms of Service (ToS) or Terms of Use (ToU). There's no practical difference between these terms and companies use them interchangeably.
        """

        descriptionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(5)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(view.snp.height).dividedBy(2.5)
        }
        
        wikiButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(descriptionView.snp.bottom).inset(10)
            make.bottom.equalTo(wikiButton.snp.top).inset(10)
        }
    }
}

private extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

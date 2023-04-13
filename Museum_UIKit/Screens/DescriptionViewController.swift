//
//  DescriptionViewController.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 09.04.2023.
//

import UIKit
import SafariServices

class DescriptionViewController: SpinnerViewController {
    
    var coordinator: CameraCoordinatorProtocol?
    var presenter: DescriptionPresenterProtocol?
    
    private var model: SerpapiModel

    init(model: SerpapiModel) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let descriptionView = WikiImageView(frame: .zero)
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 1
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = Constants.titleText
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.textColor = .secondaryLabel
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 1
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = Constants.descriptionText
        return label
    }()
    
    private lazy var wikiButton: UIButton = {
        var configuration = UIButton.Configuration.tinted()
        var container = AttributeContainer()

        container.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        configuration.attributedTitle = AttributedString("Wikipedia", attributes: container)
        configuration.image = UIImage(named: "wikiLogo")?.resized(to: CGSize(width: 22, height: 22))
        configuration.buttonSize = .large
        configuration.imagePadding = 10
        configuration.baseBackgroundColor = .label
        configuration.baseForegroundColor = .label

        let button = UIButton(configuration: configuration)
        return button
    }()
    
    private lazy var onlineButton: UIButton = {
        var configuration = UIButton.Configuration.tinted()
        var container = AttributeContainer()

        container.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        configuration.attributedTitle = AttributedString("Read Online", attributes: container)
        configuration.image = UIImage(systemName: "safari.fill")
        configuration.buttonSize = .large
        configuration.imagePadding = 10
        configuration.baseBackgroundColor = CustomColor.brandColor
        configuration.baseForegroundColor = CustomColor.brandColor

        let button = UIButton(configuration: configuration)
        return button
    }()
    
    private lazy var container: UIStackView = {
        let container = UIStackView()
        container.axis = .horizontal
        container.distribution = .fillEqually
        container.spacing = 8
        return container
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        updateUI()
        wikiButton.isHidden = false
    }
    
    private func updateUI() {
        self.descriptionView.fetchImage(imageString: model.imageURL)
        self.titleLabel.text = model.title
        self.subtitleLabel.text = model.subtitle
    }
    
    @objc private func wikiButtonPressed() {
        spinnerActivated()
        DispatchQueue.global(qos: .utility).async {
            self.presenter?.queryWikiData(query: self.model.title)
        }
    }
    
    @objc private func onlineButtonPressed() {
        guard let url = URL(string: model.link) else { return }
        let safariVC = SFSafariViewController(url: url)
        safariVC.preferredControlTintColor = .label
        present(safariVC, animated: true, completion: nil)
    }

    private func configureUI() {
        view.backgroundColor = .systemBackground
        [descriptionView, titleLabel, subtitleLabel, container].forEach(view.addSubview)
        [wikiButton, onlineButton].forEach(container.addArrangedSubview)
        
        wikiButton.addTarget(self, action: #selector(wikiButtonPressed), for: .touchUpInside)
        onlineButton.addTarget(self, action: #selector(onlineButtonPressed), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: UIAction { _ in
            self.dismiss(animated: true)
        })
        
        // MARK: - Layouts

        descriptionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(5)
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(view.snp.height).dividedBy(2.5)
        }
        
        container.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.equalTo(titleLabel.snp.bottom).inset(10)
            make.bottom.equalTo(container.snp.top).offset(-10)
        }
    }
}

extension DescriptionViewController: DescriptionViewProtocol {
    func setWikiModel(model: WikiModel) {
        spinnerDeactivated()
        wikiButton.isHidden = false
        descriptionView.fetchImage(imageString: model.imageURL)
        subtitleLabel.text = model.description
    }
    
    func setAlert(with alertItem: AlertItem?) {
        spinnerDeactivated()
        wikiButton.isHidden = true
//         Show custom error message if url request fails
        if alertItem != nil {
            let alert = UIAlertController(title: alertItem?.title,
                                          message: alertItem?.message,
                                          preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(ok)
            self.present(alert, animated: true)
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

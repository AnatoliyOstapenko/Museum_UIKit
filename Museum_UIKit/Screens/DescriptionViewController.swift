//
//  DescriptionViewController.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 09.04.2023.
//

import UIKit

class DescriptionViewController: UIViewController {
    
    var presenter: DescriptionPresenterProtocol?
    var coordinator: CameraCoordinatorProtocol?
    
    private let stringURL: String?
    private var wikiModel: WikiModel?

    init(stringURL: String) {
        self.stringURL = stringURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let descriptionView = WikiImageView(frame: .zero)
    
    private lazy var container: UIStackView = {
        let container = UIStackView()
        container.axis = .vertical
        container.distribution = .equalSpacing
        return container
    }()
    
    private lazy var subtitle: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 1
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.tintColor = .secondaryLabel
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
        configuration.baseBackgroundColor = .label
        configuration.baseForegroundColor = .label

        let button = UIButton(configuration: configuration)
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        return button
    }()
    
    private lazy var spinner: SpinnerViewController = {
        let spinner = SpinnerViewController()
        return spinner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        activateSpinnerView()
        DispatchQueue.global(qos: .utility).async {
            self.presenter?.getStringURL(stringURL: self.stringURL ?? "")
        }
    }
    
    private func activateSpinnerView() {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }

    private func deactivateSpinnerView() {
        DispatchQueue.main.async {
            self.spinner.willMove(toParent: nil)
            self.spinner.view.removeFromSuperview()
            self.spinner.removeFromParent()
        }
    }

    private func configureUI() {
        view.backgroundColor = .systemBackground
        [descriptionView, descriptionLabel, wikiButton].forEach(view.addSubview)
        descriptionLabel.backgroundColor = .clear
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: UIAction { _ in
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

extension DescriptionViewController: DescriptionViewProtocol {
    func setAlert(with alertItem: AlertItem?) {
        deactivateSpinnerView()
        if alertItem != nil {
            let alert = UIAlertController(title: alertItem?.title,
                                          message: alertItem?.message,
                                          preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(ok)
            self.present(alert, animated: true)
        }
    }
    
    func setSerpapiModel(model: WikiModel) {
        deactivateSpinnerView()
        self.descriptionView.fetchImage(imageString: model.imageURL)
        self.descriptionLabel.text = model.title
        print("Link for next step: \(model.description)")
    }
}

private extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

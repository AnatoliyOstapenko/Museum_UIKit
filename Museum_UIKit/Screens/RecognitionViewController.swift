//
//  RecognitionViewController.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 03.04.2023.
//

import UIKit
import Vision
import CoreML
import SnapKit

class RecognitionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var coordinator: CameraCoordinatorProtocol?
    var presenter: CameraPresnterProtocol?
    private var alertItem: AlertItem?
    private var wikiModel: WikiModel?
    
    private let recognitionView = WikiImageView(frame: .zero)
    
    private lazy var imagePickerVC: UIImagePickerController = {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true /// it is important to use the cropped image for further uploading to imgur
        vc.delegate = self
        return vc
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 1
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])  {
        guard let image = info[.editedImage] as? UIImage, let ciImage = CIImage(image: image) else { return }
//        guard let testImage = UIImage(named: "imageTest") else { return }
        presenter?.fetchLink(image: image)
        //recognizeImage(ciImage)
        imagePickerVC.dismiss(animated: true)
    }
    
    private func recognizeImage(_ ciImage: CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3(configuration: MLModelConfiguration()).model) else {
            return
        }
        // Handler
        let handler = VNImageRequestHandler(ciImage: ciImage)
        // Request
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let self = self, let result = request.results?.first as? VNClassificationObservation else {
                print("Request fails")
                return
            }
            
            guard let recognizedText = result.identifier.components(separatedBy: ",").first else { return }
            self.presenter?.getWikiData(query: recognizedText)
        }
        
        // Process request
        do {
            try handler.perform([request])
        } catch {
            print(error)
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addAllSubviews(recognitionView, descriptionLabel)
        descriptionLabel.backgroundColor = .clear
        
        recognitionView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalToSuperview().inset(20)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.snp.height).dividedBy(2.2)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(recognitionView.snp.bottom)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraTapped))
        navigationItem.rightBarButtonItem?.tintColor = .label
    }
    
    @objc private func cameraTapped() {
        present(imagePickerVC, animated: true)
    }
}

extension RecognitionViewController: CameraViewProtocol {
    func setLink(with stringURL: String) {
        print("Lets handling this link: \(stringURL)")
        recognitionView.getIcon(imageString: stringURL)
    }
    
    func setErorrs(with errors: NetworkingError) {
        switch errors {
        case .invalidURL: alertItem = AlertContext.invalidURL
        case .invalidResponse: alertItem = AlertContext.invalidResponse
        case .invalidData: alertItem = AlertContext.invalidData
        case .invalidTask: alertItem = AlertContext.invalidTask
        case .unableToComplete: alertItem = AlertContext.unableToComplete
        case .invalidImage: alertItem = AlertContext.invalidImage
        }
        // Show custom error message if url request fails
        
        let alert = UIAlertController(title: self.alertItem?.title,
                                      message: self.alertItem?.message,
                                      preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
    func setWikiData(with data: WikiModel) {
        self.title = data.title
        descriptionLabel.text = data.description
        recognitionView.getIcon(imageString: data.imageURL)
    }
}

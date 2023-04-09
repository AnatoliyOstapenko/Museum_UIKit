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
        guard let image = info[.editedImage] as? UIImage else { return }
        imagePickerVC.dismiss(animated: true)
        presenter?.fetchLink(image: image)
        
        /// if you need to recognize object by ML:
//        guard let ciImage = CIImage(image: image) else { return }
//        recognizeImage(ciImage)
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
//            self.presenter?.getWikiData(query: recognizedText)
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
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(view.snp.height).dividedBy(2.1)
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
    
    func setAlert(with alertItem: AlertItem?) {
        // Show custom error message if url request fails
        if alertItem != nil {
            let alert = UIAlertController(title: alertItem?.title,
                                          message: alertItem?.message,
                                          preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(ok)
            self.present(alert, animated: true)
        }
    }
    
    func setLink(with stringURL: String) {
        print("Lets handling this link: \(stringURL)")
        self.present(DescriptionViewController(stringURL: stringURL), animated: true)
//        recognitionView.getIcon(imageString: stringURL)
    }
    
//    func setWikiData(with data: WikiModel) {
//        self.title = data.title
//        descriptionLabel.text = data.description
//        recognitionView.getIcon(imageString: data.imageURL)
//    }
}

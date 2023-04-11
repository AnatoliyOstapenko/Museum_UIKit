//
//  CameraViewController.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 03.04.2023.
//

import UIKit
import Vision
import CoreML
import SnapKit

class CameraViewController: SpinnerViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var coordinator: CameraCoordinatorProtocol?
    var presenter: CameraPresnterProtocol?

    private lazy var imagePickerVC: UIImagePickerController = {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true /// it is important to use the cropped image for further uploading to Imgur
        vc.delegate = self
        return vc
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = Constants.wikiLogo
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var cameraButton: UIButton = {
        var configuration = UIButton.Configuration.tinted()
        configuration.buttonSize = .large
        configuration.imagePadding = 10
        configuration.image = SFSymbols.camera
        configuration.title = Constants.cameraTitle
        configuration.subtitle = Constants.cameraSubtitle
        configuration.baseBackgroundColor = .white
        configuration.baseForegroundColor = .white

        let button = UIButton(configuration: configuration)
        button.showsMenuAsPrimaryAction = true
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        return button
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setButtonMenu()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])  {
        guard let image = info[.editedImage] as? UIImage else { return }
        imagePickerVC.dismiss(animated: true)
        
        spinnerActivated()
        DispatchQueue.global(qos: .utility).async {
            self.presenter?.fetchLink(image: image)
        }

        /// if you need to recognize object by ML:
//        guard let ciImage = CIImage(image: image) else { return }
//        recognizeImage(ciImage)
    }
    
    // MARK: Private methods
    
    private func setButtonMenu() {
        let menu = UIMenu(title: "", children: [
            UIAction(title: "Camera", image: UIImage(systemName: "camera"), handler: handlingUIMenu),
            UIAction(title: "Photo Library", image: UIImage(systemName: "photo"), handler: handlingUIMenu),
        ])
        cameraButton.menu = menu
    }
    
    private func handlingUIMenu(action: UIAction) {
        switch action.title {
        case "Camera": self.present(imagePickerVC, animated: true)
        case "Photo Library": print("library")
        default: break
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .black
        [cameraButton, imageView].forEach(view.addSubview)

        imageView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.height.equalToSuperview().dividedBy(2)
        }
        cameraButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-30)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    // MARK: - May be uncommented in the case of a high-end ML model
    
//    private func recognizeImage(_ ciImage: CIImage) {
//        guard let model = try? VNCoreMLModel(for: Inceptionv3(configuration: MLModelConfiguration()).model) else {
//            return
//        }
//        // Handler
//        let handler = VNImageRequestHandler(ciImage: ciImage)
//        // Request
//        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
//            guard let self = self, let result = request.results?.first as? VNClassificationObservation else {
//                print("Request fails")
//                return
//            }
//
//            guard let recognizedText = result.identifier.components(separatedBy: ",").first else { return }
//            self.presenter?.getWikiData(query: recognizedText)
//        }
//
//        // Process request
//        do {
//            try handler.perform([request])
//        } catch {
//            print(error)
//        }
//    }
}

extension CameraViewController: CameraViewProtocol {
    func setSerpapiModel(model: SerpapiModel) {
        spinnerDeactivated()
        coordinator?.goToDescription(model, vc: self)
    }

    func setAlert(with alertItem: AlertItem?) {
        spinnerDeactivated()
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
        DispatchQueue.global(qos: .utility).async {
            self.presenter?.getStringURL(stringURL: stringURL)
        }
    }
}

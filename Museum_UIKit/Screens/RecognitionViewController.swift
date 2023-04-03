//
//  RecognitionViewController.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 03.04.2023.
//

import UIKit
import Vision
import CoreML

class RecognitionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private lazy var recognitionView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    private lazy var imagePickerVC: UIImagePickerController = {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = false
        vc.delegate = self
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        recognitionView.frame = view.bounds
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])  {
        guard let image = info[.originalImage] as? UIImage, let ciImage = CIImage(image: image) else { return }
       
        recognizeImage(ciImage)

        DispatchQueue.main.async {
            self.recognitionView.image = image
            self.imagePickerVC.dismiss(animated: true)
        }
    }
    
    private func recognizeImage(_ ciImage: CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3(configuration: MLModelConfiguration()).model) else {
           return
        }
        
        // Handler
        let handler = VNImageRequestHandler(ciImage: ciImage)
        // Request
        let request = VNCoreMLRequest(model: model) { request, error in
            guard let results = request.results as? [VNClassificationObservation] else {
                print("Request fails")
                return
            }
            guard let confidence = results.compactMap({$0.confidence}).first,
                  let recognizedObject = results.compactMap({$0.identifier}).first else { return }
            
            print("recognizedObject1: \(recognizedObject), confidence1: \(confidence)")
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
        view.addSubview(recognitionView)
        title = "RecognitionViewController"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(cameraTapped))
        navigationItem.rightBarButtonItem?.tintColor = .label
    }
    
    @objc private func cameraTapped() {
        present(imagePickerVC, animated: true)
    }
}

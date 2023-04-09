//
//  FirebaseViewController.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 07.04.2023.
//

import UIKit
import FirebaseStorage

class FirebaseViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let storage = Storage.storage().reference()
    
    private lazy var imagePickerVC: UIImagePickerController = {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
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
    
    private let recognitionView = WikiImageView(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        guard let stringURL = UserDefaults.standard.value(forKey: "url") as? String, let url = URL(string: stringURL) else {
            print("failed to get stringURL from defaults")
            return
        }
        
        print(stringURL)
        print("\(url)")
    }
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        view.addAllSubviews(recognitionView, descriptionLabel)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "photo"), style: .plain, target: self, action: #selector(uploadTapped))
        navigationItem.rightBarButtonItem?.tintColor = .label
        
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
    }
    
    @objc private func uploadTapped() {
        print("image was uploaded")
        self.present(imagePickerVC, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage, let imageData = image.pngData() else { return }
        
//        NetworkingManager.shared.uploadImage(image: image) { result in
//            switch result {
//            case .success(let success):
//                print(success)
//            case .failure(let failure):
//                print(failure)
//            }
//        }
        
        // upload image to firebase
//        let reference = storage.child("images/file.png")
//
//        reference.putData(imageData) { _, error in
//            guard error == nil else {
//                print("failed to upload")
//                return
//            }
//            // get download url
//            reference.downloadURL { url, error in
//                guard error == nil, let url = url else {
//                    print("failed to download")
//                    return
//                }
//
//                let stringURL = url.absoluteString
//                UserDefaults.standard.set(stringURL, forKey: "url")
//            }
//        }
        
        
        imagePickerVC.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("DidCancel")
        imagePickerVC.dismiss(animated: true)
    }
}

//
//  CameraViewController.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 31.03.2023.
//

import UIKit
import AVFoundation
import SnapKit

class CameraViewController: UIViewController {
    
    // MARK: - Object relations
    
    var coordinator: CameraCoordinatorProtocol?
    
    private var session: AVCaptureSession?
    private let output = AVCapturePhotoOutput()
    private let previewLayer = AVCaptureVideoPreviewLayer()
    
    private var takenPicture = false {
        didSet {
            shutterButton.setNeedsUpdateConfiguration()
        }
    }
    
    // MARK: - Views
    
    private lazy var shutterButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        button.layer.opacity = 0.5
        button.layer.cornerRadius = 40
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor

        button.configuration = UIButton.Configuration.plain()
        
        button.configurationUpdateHandler = { [weak self] button in
            guard let self = self else { return }
            button.backgroundColor = self.takenPicture ? .white : .clear
            button.isEnabled = !self.takenPicture
        }
        return button
    }()

    private let photoButton = CameraButton(imageName: "photo")
    private let boltModeButton = CameraButton(imageName: "bolt.fill")
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        checkCameraPermission()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer.frame = view.bounds
        shutterButton.center = CGPoint(x: view.frame.size.width / 2,
                                       y: view.frame.size.height - 80)
    }
    
    // MARK: - Private methods
    
    private func configureUI() {
        view.backgroundColor = .black
        view.layer.addSublayer(previewLayer)
        view.addAllSubviews(shutterButton, photoButton, boltModeButton)
        
        photoButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(50)
            make.centerY.equalTo(shutterButton.snp.centerY)
            make.height.width.equalTo(46)
        }
        
        boltModeButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(50)
            make.centerY.equalTo(shutterButton.snp.centerY)
            make.height.width.equalTo(46)
        }
        
        shutterButton.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(systemItem: .close, primaryAction: UIAction { _ in
            /// uncomment when registration screen will be added
            //          self.dismiss(animated: true)
        })
    }
    
    @objc private func takePhoto() {
        print("photo was taken")
        self.takenPicture = true
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: false) { _ in
            self.takenPicture = false
        }
        
        // TODO: - modify bolt mode later
//        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined: request()
        case .restricted: break
        case .denied: break
        case .authorized: setCamera()
        @unknown default: break
        }
    }
    
    private func request() {
        AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
            guard granted, let self = self else { return }
            DispatchQueue.main.async { self.setCamera() }
        }
    }
    
    private func setCamera() {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video) {
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input) { session.addInput(input) }
                if session.canAddOutput(self.output) { session.addOutput(self.output)}
              
                self.previewLayer.videoGravity = .resizeAspectFill
                self.previewLayer.session = session
                
                session.startRunning()
                self.session = session
            } catch {
                print(error)
            }
        }
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        print("photo captured complete")
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else { return }
        // stop running cam session
        self.session?.stopRunning()
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.frame = view.bounds
        view.addSubview(imageView)

    }
}

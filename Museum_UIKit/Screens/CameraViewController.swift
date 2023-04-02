//
//  CameraViewController.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 31.03.2023.
//

import UIKit
import AVFoundation

// New side

class CameraViewController: UIViewController {
    
    // MARK: - Private properties
    
    private var session: AVCaptureSession?
    private let output = AVCapturePhotoOutput()
    private let previewLayer = AVCaptureVideoPreviewLayer()
    
    private let shutterButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        button.layer.cornerRadius = 40
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    // MARK: - Object relations
    
    var coordinator: CameraCoordinatorProtocol?
    
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
        view.addSubview(shutterButton)
        shutterButton.addTarget(self, action: #selector(takePhoto), for: .touchUpInside)
    }
    
    @objc private func takePhoto() {
        print("photo was taken")
        // TODO: - modify flach mode later
        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
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


//
//  CamereButton.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 02.04.2023.
//

import UIKit

class CameraButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    convenience init(imageName: String) {
        self.init(frame: .zero)
        configuration?.image = UIImage(systemName: imageName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        configuration = .plain()
        layer.cornerRadius = 23
        layer.backgroundColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        tintColor = .white.withAlphaComponent(0.5)
        configuration?.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .large)
        translatesAutoresizingMaskIntoConstraints = false        
    }
}


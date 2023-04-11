//
//  WikiImageView.swift
//  Museum_UIKit
//
//  Created by Anatoliy Ostapenko on 06.04.2023.
//

import UIKit

class WikiImageView: UIImageView {

        lazy var presenter = WikiImagePresenter(view: self, networkManager: NetworkingManager())

        override init(frame: CGRect) {
            super.init(frame: frame)
            configure()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func configure() {
            image = UIImage(systemName: "photo.artframe")
            tintColor = .secondaryLabel
            contentMode = .scaleAspectFit
            
            /// in case you get pictures from server the same size
//            clipsToBounds = true
//            layer.cornerRadius = 10
        }
        
        func fetchImage(imageString: String?) {
            presenter.getImage(imageString: imageString ?? "")
        }
    }

extension WikiImageView: WikiImageViewProtocol {
    func setImage(image: UIImage) {
        self.image = image
    }
}

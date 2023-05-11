//
//  CharacterDetailsImageView.swift
//  Rick and Morty
//
//  Created by Luka Kilasonia on 5/5/23.
//

import UIKit

class CharacterDetailsImageView: UIView, Configurable {

    typealias ViewModel = Model
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: 250),
            imageView.widthAnchor.constraint(equalToConstant: 220),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func configure(with model: Model) {
        imageView.loadImageFromURL(URL(string: model.imageUrl)!, placeHolderImage: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
    }
}

// MARK: - Model
extension CharacterDetailsImageView {
    struct Model {
        let imageUrl: String
    }
}

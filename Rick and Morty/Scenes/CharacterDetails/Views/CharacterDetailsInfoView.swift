//
//  CharacterDetailsInfoView.swift
//  Rick and Morty
//
//  Created by Luka Kilasonia on 5/5/23.
//


import UIKit

class CharacterDetailsInfoView: UIView, Configurable {

    typealias ViewModel = Model
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .systemBrown
        return label
    }()
    
    var didTapHandler: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
        label.attach(to: self, insets: .init(top: 8, left: 16, bottom: 8, right: 16))
    }
    
    func configure(with model: Model) {
        label.text = "\(model.title): \(model.value)"
    }
    
    @objc private func tapped() {
        didTapHandler?()
    }
}

// MARK: - Model
extension CharacterDetailsInfoView {
    struct Model {
        let title: String
        let value: String
    }
}

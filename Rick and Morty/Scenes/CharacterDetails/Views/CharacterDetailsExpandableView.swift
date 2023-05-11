//
//  CharacterDetailsExpandableView.swift
//  Rick and Morty
//
//  Created by Luka Kilasonia on 5/5/23.
//

import Foundation

import UIKit

class CharacterDetailsExpandableView: UIView, Configurable {
    
    typealias ViewModel = Expandable
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .systemBrown
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    private let imageView: UIImageView = {
        let image = UIImage(named: "section_expand_dark")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [label, imageView])
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        backgroundColor = .systemGray6
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        stackView.attach(to: self, insets: .init(top: 4, left: 16, bottom: 4, right: 16))
        setupGestureRecoginzer()
    }
    
    private func setupGestureRecoginzer() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
    }
    
    @objc private func tapped() {
        didTapHandler?()
    }
    
    func configure(with model: ViewModel) {
        label.text = model.title
        animateArrow(expanded: model.isExpanded)
    }
    
    private func animateArrow(expanded: Bool) {
        UIView.animate(withDuration: 0.15) {
            self.imageView.transform = CGAffineTransform(rotationAngle: expanded ? CGFloat.pi : .zero)
        }
    }
}

// MARK: - Model
extension CharacterDetailsExpandableView {
    class Expandable {
        let title: String
        @Published var isExpanded: Bool
        @Published var sections: [CharacterDetailsEpisodeView.Model]
        
        init(title: String, isExpanded: Bool, sections: [CharacterDetailsEpisodeView.Model]) {
            self.title = title
            self.isExpanded = isExpanded
            self.sections = sections
        }
    }

}

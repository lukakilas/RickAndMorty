//
//  CharacterListItemView.swift
//  Rick and Morty
//
//  Created by Luka Kilasonia on 5/2/23.
//

import UIKit

class CharacterListItemView: UIView, Configurable {
    typealias ViewModel = Model
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.systemBrown
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let lastLocationLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.systemBrown
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let firstSeenLbl: UILabel = {
        let lbl = UILabel()
        lbl.textColor = UIColor.systemBrown
        lbl.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    private let labelsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    private func setup() {
        addSubview(imageView)
        addSubview(labelsStack)
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            imageView.widthAnchor.constraint(equalToConstant: 60),
            imageView.heightAnchor.constraint(equalToConstant: 60),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            labelsStack.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            labelsStack.topAnchor.constraint(equalTo: imageView.topAnchor),
            labelsStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            labelsStack.bottomAnchor.constraint(equalTo: imageView.bottomAnchor),
            labelsStack.heightAnchor.constraint(equalToConstant: 60)
        ])
        labelsStack.addArrangedSubview(nameLbl)
        labelsStack.addArrangedSubview(lastLocationLbl)
        labelsStack.addArrangedSubview(firstSeenLbl)
    }
    
    // MARK: - Update
    func configure(with model: Model) {
        imageView.image = nil
        nameLbl.text = model.name
        lastLocationLbl.text = model.gender.rawValue
        firstSeenLbl.text = model.species
        guard let url = URL(string: model.image ?? "") else {
            imageView.image = nil
            return
        }
        imageView.loadImageFromURL(url, placeHolderImage: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
    }
    
}
// MARK: - Model
extension CharacterListItemView {
    struct Model {
        let image: String?
        let name: String
        let gender: Gender
        let status: Status
        let species: String
    }
}

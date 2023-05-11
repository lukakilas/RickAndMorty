//
//  CharacterDetailsEpisodeCell.swift
//  Rick and Morty
//
//  Created by Luka Kilasonia on 5/5/23.
//

import UIKit
import Combine

class CharacterDetailsEpisodeView: UIView, Configurable {
    typealias ViewModel = Model
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .systemBrown
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = 2
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = .init(width: 70, height: 50)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(GenericCollectionViewCell<CharacterDetailsCircledImageView>.self, forCellWithReuseIdentifier: "CircledCharacterImageView")
        return collection
    }()
    
    private lazy var collectionHeightAnchor = NSLayoutConstraint(item: collectionView,
                                                            attribute: .height,
                                                            relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0)
    
    var model: Model?
    
    private var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    var expandTapped: ((Bool) -> Void)?
    var didChooseCharacter: ((String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
        stackView.attach(to: self, insets: .init(top: 10, left: 16, bottom: 10, right: 16))
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(collectionView)
        setupCollectionView()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionHeightAnchor.isActive = true // set a fixed height
    }
    
    private func animateHeightChange(for expanded: Bool, animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.2) {
                self.collectionHeightAnchor.constant = expanded ? 70 : 0
                self.layoutIfNeeded()
            }
        } else {
            self.collectionHeightAnchor.constant = expanded ? 70 : 0
            collectionView.reloadData()
        }

    }
    
    func configure(with model: Model) {
        self.model = model
        label.text = model.title
        animateHeightChange(for: self.model!.expanded, animated: false)
    }
    
    @objc private func tapped() {
        model?.expanded.toggle()
        animateHeightChange(for: model!.expanded, animated: true)
        expandTapped?(model!.expanded)
    }
}
// MARK: - CollectionViewDataSource
extension CharacterDetailsEpisodeView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model?.data.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = model?.data[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CircledCharacterImageView", for: indexPath) as! GenericCollectionViewCell<CharacterDetailsCircledImageView>
        cell.view.configure(with: item!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let episode = model?.data[indexPath.row] else { return }
        didChooseCharacter?(episode)
    }
}

// MARK: - Model
extension CharacterDetailsEpisodeView {
    class Model {
        var title: String
        var data: [String]
        @Published var expanded: Bool
        
        init(data: [String], title: String, expanded: Bool = false) {
            self.data = data
            self.title = title
            self.expanded = expanded
        }
    }
}

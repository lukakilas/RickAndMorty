//
//  GenericTableViewCell.swift
//  Rick and Morty
//
//  Created by Luka Kilasonia on 5/3/23.
//

import UIKit

protocol Configurable {
    associatedtype ViewModel
    func configure(with model: ViewModel)
}

class GenericTableViewCell<T: UIView>: UITableViewCell {
    
    let view = T()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.attach(to: contentView)
        view.constraints.first(where: { $0.firstAttribute == .bottom})?.priority = .init(200)
        view.constraints.first(where: { $0.firstAttribute == .trailing})?.priority = .init(950)
    }
}

//
//  EmptyListView.swift
//  Rick and Morty
//
//  Created by Luka Kilasonia on 5/11/23.
//

import UIKit

class EmptyListView: UIView {
    
    var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "empty_dataSource"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.attach(to: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

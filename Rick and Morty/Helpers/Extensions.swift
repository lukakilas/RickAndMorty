//
//  BaseViewController.swift
//  Rick and Morty
//
//  Created by Luka Kilasonia on 5/3/23.
//

import UIKit
import Combine
// MARK: - ViewControllerExtensions
extension UIViewController {
    func showAlert(error: Error) {
        let alert = UIAlertController(title: "Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: - ViewExtensions
extension UIView {
    func addSubViews(_ subviews: UIView...) {
        subviews.forEach(addSubview(_:))
    }
    
    func attach(to: UIView, insets: UIEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)) {
        to.addSubview(self)
        NSLayoutConstraint.activate([
            leftAnchor.constraint(equalTo: to.leftAnchor, constant: insets.left),
            rightAnchor.constraint(equalTo: to.rightAnchor, constant: -insets.right),
            topAnchor.constraint(equalTo: to.topAnchor, constant: insets.top),
            bottomAnchor.constraint(equalTo: to.bottomAnchor, constant: -insets.bottom),
        ])
    }
}
// MARK: - UIImageViewExtensions
extension UIImageView {
    func createLoader() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor.systemBrown
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }
    
    private func animate(loader: UIActivityIndicatorView, _ boolean: Bool) {
        if boolean {
            addSubview(loader)
            loader.startAnimating()
            NSLayoutConstraint.activate([
                loader.centerYAnchor.constraint(equalTo: centerYAnchor),
                loader.centerXAnchor.constraint(equalTo: centerXAnchor),
                loader.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3),
                loader.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3)
            ])
        } else {
            loader.stopAnimating()
            loader.removeFromSuperview()
        }
        
    }

    func loadImageFromURL(_ url: URL, placeHolderImage: UIImage?) {
        let config = URLSessionConfiguration.default
        let loader = createLoader()
        let session = URLSession(configuration: config)
        DispatchQueue.main.async {
            self.animate(loader: loader, true)
        }
        let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            guard let imageData = data, let image = UIImage(data: imageData) else {
                DispatchQueue.main.async {
                    self?.image = placeHolderImage
                }
                return
            }
            DispatchQueue.main.async {
                self?.animate(loader: loader, false)
                self?.image = image
            }
        }
        
        task.resume()
    }
}

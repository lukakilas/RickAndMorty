//
//  CharactersListRouter.swift
//  Rick and Morty
//
//  Created by Luka Kilasonia on 5/5/23.
//

import UIKit

protocol Router {
    var navigationController: UINavigationController { get }
}

protocol CharacterDetailsRoutable: Router {
    func showDetailsScreen(character: Character)
}

protocol CharactersListRoutable: CharacterDetailsRoutable { }

class CharactersListRouter: CharactersListRoutable {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showDetailsScreen(character: Character) {
        let viewModel = CharacterDetailsViewModel(character: character)
        navigationController.pushViewController(CharacterDetailsScreen(viewModel: viewModel,
                                                                       router: self), animated: true)
    }
}

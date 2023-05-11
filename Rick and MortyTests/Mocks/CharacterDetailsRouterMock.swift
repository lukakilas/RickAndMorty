//
//  CharacterDetailsRouterMock.swift
//  Rick and MortyTests
//
//  Created by Luka Kilasonia on 5/10/23.
//

import UIKit
@testable import Rick_and_Morty

struct CharacterDetailsRouterMock: CharacterDetailsRoutable {
    var navigationController: UINavigationController = UINavigationController()
    
    func showDetailsScreen(character: Character) {
        
    }
}

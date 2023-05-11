//
//  CharacterByIdUseCase.swift
//  Rick and Morty
//
//  Created by Luka Kilasonia on 5/10/23.
//

import Combine

protocol FetchCharacterByIdUseCase {
    func fetchSelectedCharacter(url: String) -> AnyPublisher<Character, Error>
}

class FetchCharacterByIdUseCaseImpl: FetchCharacterByIdUseCase {
    private var client: CharacterByIdClient!
    
    func fetchSelectedCharacter(url: String) -> AnyPublisher<Character, Error> {
        client = CharacterByIdClient(url: url)
        return client.performAndParse(to: Character.self)
    }
}


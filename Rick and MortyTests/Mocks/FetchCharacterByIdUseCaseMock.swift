//
//  FetchCharacterByIdUseCaseMock.swift
//  Rick and MortyTests
//
//  Created by Luka Kilasonia on 5/11/23.
//

import Combine
@testable import Rick_and_Morty
struct FetchCharacterByIdUseCaseMock: FetchCharacterByIdUseCase {
    func fetchSelectedCharacter(url: String) -> AnyPublisher<Character, Error> {
        return Future<Character, Error> { promise in
            let character = CharactersMock().getList()[0]
            promise(.success(character))
        }.eraseToAnyPublisher()

    }
}

//
//  CharacterForEpisodeUseCaseMock.swift
//  Rick and MortyTests
//
//  Created by Luka Kilasonia on 5/11/23.
//

import Combine
@testable import Rick_and_Morty

struct CharacterForEpisodeUseCaseMock: CharacterForEpisodeUseCase {
    func fetchCharacters(episodeUrl: String) -> AnyPublisher<CharacterForEpisodeResponse, Error> {
        return Future<CharacterForEpisodeResponse, Error> { promise in
            promise(.success(.init(characters: [
                "https://rickandmortyapi.com/api/character/1",
                "https://rickandmortyapi.com/api/character/35",
                "https://rickandmortyapi.com/api/character/38",
            ])))
        }.eraseToAnyPublisher()
    }
}


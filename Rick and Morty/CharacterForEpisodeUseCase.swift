//
//  CharacterForEpisodeUseCase.swift
//  Rick and Morty
//
//  Created by Luka Kilasonia on 5/5/23.
//

import Combine

protocol CharacterForEpisodeUseCase {
    func fetchCharacters(episodeUrl: String) -> AnyPublisher<CharacterForEpisodeResponse, Error>
}

class CharacterForEpisodeUseCaseImpl: CharacterForEpisodeUseCase {
    private var client: CharactersForEpisodeClient!
    
    func fetchCharacters(episodeUrl: String) -> AnyPublisher<CharacterForEpisodeResponse, Error> {
        client = CharactersForEpisodeClient(url: episodeUrl)
        return client.performAndParse(to: CharacterForEpisodeResponse.self)
    }
}

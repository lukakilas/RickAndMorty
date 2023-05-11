//
//  CharactesUseCase.swift
//  Rick and Morty
//
//  Created by Luka Kilasonia on 5/2/23.
//

import Foundation
import Combine

protocol FetchCharactersUseCaseable {
    func fetchCharacters(page: Int, searchText: String) -> AnyPublisher<CharactersResponse, Error>
}

class FetchCharactersUseCase: FetchCharactersUseCaseable {
    private var client: CharacterListClient!
    
    func fetchCharacters(page: Int, searchText: String) -> AnyPublisher<CharactersResponse, Error> {
        var queryItems: [URLQueryItem] = [.init(name: "page", value: String(page))]
        let searchQuery: URLQueryItem? = searchText.isEmpty ? .none : .init(name: "name", value: searchText)
        if searchQuery != nil { queryItems.append(searchQuery!) }
        client = CharacterListClient(path: "character", queryItems: queryItems)
        return client.performAndParse(to: CharactersResponse.self)
    }
}

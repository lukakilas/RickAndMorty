//
//  FetchCharactersUseCaseMock.swift
//  Rick and MortyTests
//
//  Created by Luka Kilasonia on 5/9/23.
//

import Foundation
import Combine
@testable import Rick_and_Morty

struct FetchCharactersUseCaseMock: FetchCharactersUseCaseable {
    private let success: Bool
    
    init(success: Bool) {
        self.success = success
    }
    
    func fetchCharacters(page: Int, searchText: String) -> AnyPublisher<CharactersResponse, Error> {
        return Future<CharactersResponse, Error> { promise in
            let results = CharactersMock().getList()
            success == true ? promise(.success(.init(info: .init(count: results.count, pages: 2, next: "nextPage"),
                                       results: results))) : promise(.failure(NetworkError.parsingError("Error")))
        }.eraseToAnyPublisher()
    }
}

//
//  NetworkTests.swift
//  Rick and MortyTests
//
//  Created by Luka Kilasonia on 5/11/23.
//

import XCTest
@testable import Rick_and_Morty

final class NetworkTests: XCTestCase {
    
    func test_CharacterListClient() {
        let sut = CharacterListClient(path: "character", queryItems: [.init(name: "page", value: "1")])
        XCTAssertEqual(sut.constructedUrl()?.absoluteString, "https://rickandmortyapi.com/api/character?page=1")
    }
    
    func test_CharacterForEpisodeClient() {
        let sut = CharactersForEpisodeClient(url: "https://rickandmortyapi.com/api/episode/1")
        XCTAssertEqual(sut.constructedUrl()?.absoluteString, "https://rickandmortyapi.com/api/episode/1")
    }
}

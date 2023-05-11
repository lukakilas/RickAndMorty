//
//  CharactersMock.swift
//  Rick and MortyTests
//
//  Created by Luka Kilasonia on 5/11/23.
//

import Foundation
@testable import Rick_and_Morty

struct CharactersMock {
    func getList() -> [Character] {
        return [
            createCharacter(name: "Rick", id: 1),
            createCharacter(name: "John", id: 2),
            createCharacter(name: "Sam", id: 3),
            createCharacter(name: "Rick", id: 4),
            createCharacter(name: "Morty", id: 5),
            createCharacter(name: "Summer", id: 6),
            createCharacter(name: "Jerry", id: 7),
            createCharacter(name: "Abraldof", id: 8)
        ]
    }
    
    private func createCharacter(name: String, id: Int) -> Character {
        return Character(id: id,
                         name: name,
                         status: .alive,
                         species: "Human",
                         type: "",
                         gender: .male,
                         origin: .init(name: "Earth (C-137)", url: "https://rickandmortyapi.com/api/location/1"),
                         location: .init(name: "Citadel of Ricks", url: "https://rickandmortyapi.com/api/location/3"),
                         image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                         episode: [
                            "https://rickandmortyapi.com/api/episode/1",
                            "https://rickandmortyapi.com/api/episode/2",
                            "https://rickandmortyapi.com/api/episode/3",
                         ], url: "https://rickandmortyapi.com/api/character/1",
                         created: "2017-11-04T18:48:46.250Z")
    }
}

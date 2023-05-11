//
//  CharacterListClient.swift
//  Rick and Morty
//
//  Created by Luka Kilasonia on 5/9/23.
//

import Foundation

class CharacterListClient: NetworkClient {
    override init(path: String, queryItems: [URLQueryItem] = []) {
        super.init(path: path, queryItems: queryItems)
    }
}

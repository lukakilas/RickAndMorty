//
//  Character.swift
//  Rick and Morty
//
//  Created by Luka Kilasonia on 5/3/23.
//

import Foundation

// MARK: - Welcome
struct CharactersResponse: Codable {
    let info: Info
    let results: [Character]
}

// MARK: - Info
struct Info: Codable {
    let count: Int
    let pages: Int
    let next: String?
}

// MARK: - Result
struct Character: Codable {
    let id: Int
    let name: String
    let status: Status
    let species: String
    let type: String
    let gender: Gender
    let origin, location: Location
    let image: String
    let episode: [String]
    let url: String
    let created: String
}

extension Character {
    var formattedCreationDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: created)
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        guard let date = date else {
            return "-"
        }
        return formatter.string(from: date)
    }
}

// MARK: - Gender
enum Gender: String, Codable {
    case female = "Female"
    case male = "Male"
    case genderLess = "Genderless"
    case unknown = "unknown"
}

// MARK: - Location
struct Location: Codable {
    let name: String
    let url: String
}

enum Status: String, Codable {
    case alive = "Alive"
    case dead = "Dead"
    case unknown = "unknown"
}

//
//  Network.swift
//  Rick and Morty
//
//  Created by Luka Kilasonia on 5/2/23.
//

import Foundation
import Combine

enum NetworkError: Error {
    case urlConstructionError
    case parsingError(String)
}

class NetworkClient {
    
    private let decoder = JSONDecoder()
    private var baseUrl = URL(string: "https://rickandmortyapi.com/api/")
    private var path: String?
    private var queryItems: [URLQueryItem] = []
    
    init(path: String, queryItems: [URLQueryItem]) {
        self.path = path
        self.queryItems = queryItems
    }
    
    init(url: String) {
        self.baseUrl = URL(string: url)
    }
    
    func constructedUrl() -> URL? {
        guard let path = path else {
            return baseUrl
        }
        let url = baseUrl?.appending(path: path)
        return queryItems.isEmpty ? url : url?.appending(queryItems: queryItems)
    }
    
    func performAndParse<T: Decodable>(to type: T.Type) -> AnyPublisher<T, Error> {
        guard let url = constructedUrl() else {
            return Result.Publisher(.failure(NetworkError.urlConstructionError)).eraseToAnyPublisher()
        }
        print(url)
        let request = URLRequest(url: url)
        var task: URLSessionDataTask?
        return Future<T, Error> { promise in
            task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard let data = data, error == nil else {
                    promise(.failure(NetworkError.parsingError("Data is nil")))
                    return
                }
                do {
                    let decodedObject = try JSONDecoder().decode(T.self, from: data)
                    promise(.success(decodedObject))
                } catch {
                    promise(.failure(NetworkError.parsingError("\(url)\n \(error.localizedDescription)")))
                }
            }
        }
        .handleEvents(receiveRequest:  { _ in
            task?.resume()
        })
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
}

//
//  CharactersListViewModel.swift
//  Rick and Morty
//
//  Created by Luka Kilasonia on 5/2/23.
//

import Foundation
import Combine

class CharactersListViewModelImpl: GenericListViewModel {
    
    typealias DataSourceType = CharacterListItemView.Model
    private let charactersService: FetchCharactersUseCaseable
    @Published var dataSource: [DataSourceType] = []
    @Published var dataLoadingState: DataLoadingState = .loading
    @Published private(set) var characters: [Character] = []
    @Published var searchText: String = ""
    @Published private(set) var page: Int? = 1
    private var bindings = Set<AnyCancellable>()
    

    init(charactersService: FetchCharactersUseCaseable = FetchCharactersUseCase()) {
        self.charactersService = charactersService
        fetchCharacters()
        setupDataSource()
        setupSearchTextBinding()
    }

    func fetchCharacters() {
        guard let page = page else { return }
        charactersService.fetchCharacters(page: page, searchText: searchText).sink(receiveCompletion: resultHanlder) { [weak self] response in
            self?.handleResponse(response)
        }.store(in: &bindings)
    }
    
    private func handleResponse(_ response: CharactersResponse) {
        if searchText.isEmpty == true {
            characters = page == 1 ? response.results : characters + response.results
        } else {
            characters = response.results
        }
        if page != nil {
            page! += 1
        }
    }
    
    private func setupSearchTextBinding() {
        $searchText.receive(on: RunLoop.main).sink { [weak self] value in
            self?.page = 1
            self?.fetchCharacters()
        }.store(in: &bindings)
    }
    
    private func setupDataSource() {
        $characters.sink { [weak self] value in
            self?.constructDataSource(from: value)
        }.store(in: &bindings)
    }
    
    func constructDataSource(from characters: [Character]) {
        if searchText.isEmpty {
            dataSource = characters.map { createListItemModel(from: $0) }
        } else {
            dataSource = characters.filter { $0.name.lowercased().contains(searchText.lowercased()) }.map { createListItemModel(from: $0) }
        }
    }
    
    private func createListItemModel(from character: Character) -> CharacterListItemView.Model {
        .init(image: character.image,
              name: character.name,
              gender: character.gender,
              status: character.status,
              species: character.species)
    }
    
    var resultHanlder: (Subscribers.Completion<Error>) -> Void {
        let handler: (Subscribers.Completion<Error>) -> Void = { [weak self] result in
            switch result {
            case .failure(let error):
                self?.dataLoadingState = .error(error)
            case .finished:
                self?.dataLoadingState = .finishedLoading
            }
        }
        return handler
    }

}


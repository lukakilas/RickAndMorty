//
//  CharacterDetailsViewModel.swift
//  Rick and Morty
//
//  Created by Luka Kilasonia on 5/8/23.
//

import Foundation
import Combine

class CharacterDetailsViewModel: GenericViewModel {

    @Published var dataSource: CharacterDetailsDataSource!
    @Published var episodesSectionExpanded = false
    @Published var dataLoadingState: DataLoadingState = .none
    let iconsFinishedLoading = PassthroughSubject<Void, Never>()

    private var bindings = Set<AnyCancellable>()
    private let characterForEpisodeUseCase: CharacterForEpisodeUseCase
    private let characterDetailsUseCase: FetchCharacterByIdUseCase
    let character: Character
    var selectedEpisode = ""
    var indexPathsToReload: [IndexPath] = []
    
    private var charactersInEpisode: [String: [Character]] = [:]
    private var characterUrlsForEpisode: [String: [String]] = [:]
    
    init(character: Character,
         usecase: CharacterForEpisodeUseCase = CharacterForEpisodeUseCaseImpl(),
         characterDetailsUseCase: FetchCharacterByIdUseCase = FetchCharacterByIdUseCaseImpl()) {
        self.character = character
        self.characterForEpisodeUseCase = usecase
        self.characterDetailsUseCase = characterDetailsUseCase
        setup()
    }
    
    private func setup() {
        createDataSource()
        setupBindings()
    }
    
    func createDataSource() {
        let expandable: CharacterDetailsExpandableView.Expandable = .init(title: "Episodes",
                                                                          isExpanded: false,
                                                                          sections: constructEpisodesSections())
        dataSource = .init(image: .init(imageUrl: character.image),
                           info: [CharacterDetailsInfoView.Model(title: "Creation Date", value: character.formattedCreationDate),
                                  CharacterDetailsInfoView.Model(title: "Gender", value: character.gender.rawValue),
                                  CharacterDetailsInfoView.Model(title: "Species", value: character.species),
                                  CharacterDetailsInfoView.Model(title: "Status", value: character.status.rawValue)],
                           expandable: expandable)
        
    }
    
    func setupBindings() {
        dataSource.expandable.sections.forEach { item in
            item.$expanded.receive(on: RunLoop.main).sink { [weak self] boolean in
                guard boolean == true else { return }
                self?.fetchCharacterFor(episode: item.title) { values in
                    item.data = values
                    self?.iconsFinishedLoading.send()
                }
            }.store(in: &bindings)
        }
    }
    
    private func constructEpisodesSections() -> [CharacterDetailsEpisodeView.Model] {
        return character.episode.map { item in
            let icons = charactersInEpisode[item]?.compactMap {$0.image} ?? []
            return CharacterDetailsEpisodeView.Model(data: icons,
                                                     title: item,
                                                     expanded: false)
        }
    }
    
    func getCharacter(with episode: String, imageUrl: String) -> Character? {
        return charactersInEpisode[episode]?.first(where: {$0.image == imageUrl })
    }
    
}
// MARK: - Api Calls
extension CharacterDetailsViewModel {
    func fetchCharacterFor(episode: String, completed: @escaping ([String]) -> Void) {
        if let characters = charactersInEpisode[episode] {
            completed(characters.map {$0.image})
        } else {
            fetchCharacterUrls(for: episode) { [weak self] urls in
                self?.fetchGroupedCharacters(with: urls, for: episode, completion: completed)
            }
        }
    }
    
    func fetchGroupedCharacters(with urls: [String], for episode: String, completion: @escaping([String]) -> Void) {
        let group = DispatchGroup()
        var images: [String] = []
        urls.forEach { url in
            group.enter()
            characterDetailsUseCase.fetchSelectedCharacter(url: url).sink(receiveCompletion: resultHanlder) { [weak self] character in
                guard let self = self else { return }
                group.leave()
                let exists = self.charactersInEpisode[episode]
                exists == nil ?
                self.charactersInEpisode[episode] = [character] :
                self.charactersInEpisode[episode]?.append(character)
                images.append(character.image)
            }.store(in: &bindings)
        }
        group.notify(queue: DispatchQueue.main) {
            completion(images)
        }
    }
    
    // URLs of characters in episode
    private func fetchCharacterUrls(for episode: String, completed: @escaping ([String]) -> Void) {
        if let existing = characterUrlsForEpisode[episode] {
            completed(existing)
        } else {
            characterForEpisodeUseCase.fetchCharacters(episodeUrl: episode)
                .receive(on: RunLoop.main)
                .sink(receiveCompletion: resultHanlder, receiveValue: { [weak self] response in
                    self?.characterUrlsForEpisode[episode] = response.characters
                    completed(response.characters)
                }).store(in: &bindings)
        }
    }
}

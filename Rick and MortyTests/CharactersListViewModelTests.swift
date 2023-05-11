//
//  CharactersListViewModelTests.swift
//  Rick and MortyTests
//
//  Created by Luka Kilasonia on 5/9/23.
//

import XCTest
@testable import Rick_and_Morty

final class CharactersListViewModelTests: XCTestCase {

    func test_data_fetch_succeed() {
        let sut = createSut(usecase: FetchCharactersUseCaseMock(success: true))
        XCTAssertEqual(sut.characters.count, 8)
    }
    
    func test_data_fetch_failure() {
        let sut = createSut(usecase: FetchCharactersUseCaseMock(success: false))
        sut.fetchCharacters()
        XCTAssertEqual(sut.characters.count, 0)
    }
    
    func test_search() {
        let sut = createSut(usecase: FetchCharactersUseCaseMock(success: true))
        sut.searchText = "Rick"
        sut.constructDataSource(from: sut.characters)
        XCTAssertEqual(sut.dataSource.count, 2)
        
        sut.searchText = ""
        sut.constructDataSource(from: sut.characters)
        XCTAssertEqual(sut.dataSource.count, 8)
    }
    
    func createSut(usecase: FetchCharactersUseCaseMock) -> CharactersListViewModelImpl {
        return CharactersListViewModelImpl(charactersService: usecase)
    }

}

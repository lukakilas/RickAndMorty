//
//  CharacterDetailsViewModelTests.swift
//  Rick and MortyTests
//
//  Created by Luka Kilasonia on 5/10/23.
//

import XCTest
import Combine
@testable import Rick_and_Morty

final class CharacterDetailsViewModelTests: XCTestCase {

    func test_dataSource_isValid() {
        let sut = createSut()
        XCTAssertNotNil(sut.dataSource)
        XCTAssertEqual(sut.dataSource.info.count, 4)
        XCTAssertEqual(sut.dataSource.expandable.isExpanded, false)
    }
    
    func test_dataSource_functions() {
        let sut = createSut()
        XCTAssertEqual(sut.dataSource.numberOfSections(), 3)
    }
    
    func createSut() -> CharacterDetailsViewModel {
        let character: Character = CharactersMock().getList()[0]
        let sut = CharacterDetailsViewModel(character: character,
                                            usecase: CharacterForEpisodeUseCaseMock(),
                                            characterDetailsUseCase: FetchCharacterByIdUseCaseMock())
        return sut
    }

}

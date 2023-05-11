//
//  CharacterDetailsScreenTests.swift
//  Rick and MortyTests
//
//  Created by Luka Kilasonia on 5/10/23.
//

import XCTest
@testable import Rick_and_Morty

final class CharacterDetailsListTests: XCTestCase {
    
    func test_dataSource() {
        let sut = createSut()
        sut.viewDidLoad()
        
        XCTAssertEqual(sut.listView.tableView.numberOfSections, 3)
        XCTAssertEqual(sut.listView.tableView.numberOfRows(inSection: 0), 1)
        XCTAssertEqual(sut.listView.tableView.numberOfRows(inSection: 1), 4)
    }
    
    func test_valid_cells() {
        let sut = createSut()
        sut.viewDidLoad()
        
        let tableView = sut.listView.tableView
        let randomRowForInfoSection = Int.random(in: 0...sut.listView.tableView.numberOfRows(inSection: 1))
        let imageCell = sut.listView.tableView(tableView, cellForRowAt: .init(row: 0, section: 0)) as? GenericTableViewCell<CharacterDetailsImageView>
        let infoCell = sut.listView.tableView(tableView, cellForRowAt: .init(row: randomRowForInfoSection,
                                                                            section: 1)) as? GenericTableViewCell<CharacterDetailsInfoView>
        let expandableCell = sut.listView.tableView(tableView,
                                                    cellForRowAt: .init(row: 0, section: 2)) as? GenericTableViewCell<CharacterDetailsExpandableView>
        
        XCTAssertNotNil(imageCell)
        XCTAssertNotNil(infoCell)
        XCTAssertNotNil(expandableCell)
    }
    
    func test_episode_expansion() {
        let sut = createSut()
        sut.viewDidLoad()
        
        sut.viewModel.dataSource.expandable.sections[0].expanded.toggle()
        
        let tableView = sut.listView.tableView
        let episodeCell = sut.listView.tableView(tableView,
                                                    cellForRowAt: .init(row: 1, section: 3)) as? GenericTableViewCell<CharacterDetailsEpisodeView>
        XCTAssertNotNil(episodeCell)
    }
    
    func createSut() ->  CharacterDetailsScreen {
        let character: Character = CharactersMock().getList()[0]
        let vc =  CharacterDetailsScreen(viewModel: CharacterDetailsViewModel(character: character),
                                         router: CharacterDetailsRouterMock())
        return vc
    }

}



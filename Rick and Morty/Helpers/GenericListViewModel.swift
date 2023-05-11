//
//  GenericListViewModel.swift
//  Rick and Morty
//
//  Created by Luka Kilasonia on 5/10/23.
//

import Foundation

protocol GenericListViewModel: GenericViewModel, DataSource {
    associatedtype DataSourceType
    var dataSource: [DataSourceType] { get set }
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func item(at indexPath: IndexPath) -> Any
}

extension GenericListViewModel {
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfItems(in section: Int) -> Int {
        return dataSource.count
    }
    
    
    func item(at indexPath: IndexPath) -> Any {
        return dataSource[indexPath.row]
    }
    
}

//
//  DataSource.swift
//  Rick and Morty
//
//  Created by Luka Kilasonia on 5/9/23.
//

import Foundation

class CharacterDetailsDataSource: DataSource, ObservableObject {
    let image: CharacterDetailsImageView.Model
    let info: [CharacterDetailsInfoView.Model]
    let expandable: CharacterDetailsExpandableView.Expandable
    
    init(image: CharacterDetailsImageView.Model,
         info: [CharacterDetailsInfoView.Model],
         expandable: CharacterDetailsExpandableView.Expandable) {
        self.image = image
        self.info = info
        self.expandable = expandable
    }
    
    func numberOfSections() -> Int {
        return 3
    }
    
    func numberOfItems(in section: Int) -> Int {
        if section == .zero {
            return 1
        } else if section == 1 {
            return info.count
        } else {
            return expandable.isExpanded ? expandable.sections.count + 1 : 1
        }
    }
    
    func item(at indexPath: IndexPath) -> Any {
        if indexPath.section == .zero {
            return image
        } else if indexPath.section == 1 {
            return info[indexPath.row]
        } else {
            if indexPath.row == .zero {
                return expandable
            }
            return expandable.sections[indexPath.row-1]
        }
    }
    
}

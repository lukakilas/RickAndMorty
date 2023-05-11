//
//  DataLoadingState.swift
//  Rick and Morty
//
//  Created by Luka Kilasonia on 5/10/23.
//

import Foundation

enum DataLoadingState {
    case none
    case loading
    case finishedLoading
    case error(Error)
}

//
//  GenericViewModel.swift
//  Rick and Morty
//
//  Created by Luka Kilasonia on 5/10/23.
//

import Combine

protocol GenericViewModel: AnyObject {
    var dataLoadingState: DataLoadingState { get set }
}

extension GenericViewModel {
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

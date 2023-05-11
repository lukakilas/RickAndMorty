//
//  ViewController.swift
//  Rick and Morty
//
//  Created by Luka Kilasonia on 5/2/23.
//

import UIKit
import Combine

class CharactersListScreen: UIViewController {

    private let listView: ListView = {
        let table = ListView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()

    private var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Character"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private let viewModel = CharactersListViewModelImpl()
    private var bindings = Set<AnyCancellable>()
    private lazy var router = CharactersListRouter(navigationController: self.navigationController!)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBindings()
    }
    
    private func setupBindings() {
        viewModel.$dataLoadingState
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                if case let .error(error) = state {
                    self?.showAlert(error: error)
                }
            }.store(in: &bindings)
        
        viewModel.$dataSource
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] value in
                self?.listView.reloadData()
                self?.listView.showError(value.isEmpty)
            })
            .store(in: &bindings)
        
    }
    
    private func setupView() {
        view.addSubViews(searchBar, listView)
        NSLayoutConstraint.activate([
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 44),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            listView.leftAnchor.constraint(equalTo: view.leftAnchor),
            listView.rightAnchor.constraint(equalTo: view.rightAnchor),
            listView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            listView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        setupTableView()
        searchBar.delegate = self
    }
    
    private func setupTableView() {
        listView.dataSource = viewModel
        listView.tableView.delegate = self
        registerCells()
    }
    
    private func registerCells() {
        listView.register(item: CharacterListItemView.Model.self, forCell: GenericTableViewCell<CharacterListItemView>.self) { cell, indexPath, item in
            cell.view.configure(with: item)
            cell.selectionStyle = .none
        }
    }
    
}

// MARK: - TableView Delegate
extension CharactersListScreen: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router.showDetailsScreen(character: viewModel.characters[indexPath.row])
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if shouldLoadMore(scrollView) {
            viewModel.fetchCharacters()
        }
    }
    
    private func shouldLoadMore(_ scrollView: UIScrollView) -> Bool {
        if scrollView.contentSize.height > scrollView.frame.size.height,
           scrollView.contentSize.height - scrollView.contentOffset.y <= scrollView.frame.size.height {
            return true
        }
        return false
    }
}
// MARK: - SearchBar Delegate
extension CharactersListScreen: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchText = searchText
    }
}


//
//   CharacterDetailsScreen.swift
//  Rick and Morty
//
//  Created by Luka Kilasonia on 5/9/23.
//

import UIKit
import Combine

class CharacterDetailsScreen: UIViewController {

    private(set) var viewModel: CharacterDetailsViewModel!

    let listView: ListView = {
        let listView = ListView()
        listView.translatesAutoresizingMaskIntoConstraints = false
        return listView
    }()

    private var bindings = Set<AnyCancellable>()
    private var router: CharacterDetailsRoutable
    
    init(viewModel: CharacterDetailsViewModel,
         router: CharacterDetailsRoutable) {
        self.viewModel = viewModel
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGenericTableView()
        
        viewModel.$dataSource
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.listView.reloadData()
            }.store(in: &bindings)
        
        viewModel.iconsFinishedLoading
            .receive(on: RunLoop.main)
            .sink { [weak self] boolean in
                guard let self = self else { return }
                self.listView.tableView.reloadRows(at: self.viewModel.indexPathsToReload, with: .fade)
            }.store(in: &bindings)
    }

    func setupGenericTableView() {
        listView.dataSource = viewModel.dataSource
        listView.attach(to: view)
        
        listView.register(item: CharacterDetailsInfoView.Model.self,
                          forCell: GenericTableViewCell<CharacterDetailsInfoView>.self) { cell, indexPath, item in
            cell.view.configure(with: item)
            cell.selectionStyle = .none
        }

        listView.register(item: CharacterDetailsImageView.Model.self,
                          forCell: GenericTableViewCell<CharacterDetailsImageView>.self) { cell, indexPath, item in
            cell.view.configure(with: item)
            cell.selectionStyle = .none
        }

        listView.register(item: CharacterDetailsExpandableView.Expandable.self,
                          forCell: GenericTableViewCell<CharacterDetailsExpandableView>.self) { [unowned self]
            cell, indexPath, item in
            cell.view.configure(with: item)
            cell.view.didTapHandler = {
                if indexPath.section == 2, indexPath.row == .zero {
                    self.viewModel.dataSource.expandable.isExpanded.toggle()
                    self.listView.reloadData()
                }
            }
        }
        
        listView.register(item: CharacterDetailsEpisodeView.Model.self,
                          forCell: GenericTableViewCell<CharacterDetailsEpisodeView>.self) { [unowned self] cell, indexPath, item in
            cell.view.configure(with: item)
            cell.selectionStyle = .none
            cell.view.expandTapped = { exanded in
                self.viewModel.indexPathsToReload = [indexPath]
                self.listView.tableView.reloadRows(at: [indexPath], with: .fade)
            }
            
            cell.view.didChooseCharacter = { imageUrl in
                if let character = self.viewModel.getCharacter(with: item.title, imageUrl: imageUrl) {
                    self.router.showDetailsScreen(character: character)
                }
            }
        }
        
    }
}

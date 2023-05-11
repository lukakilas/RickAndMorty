//
//  GenericTableView.swift
//  Rick and Morty
//
//  Created by Luka Kilasonia on 5/4/23.
//

import UIKit

protocol DataSource: AnyObject {
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func item(at indexPath: IndexPath) -> Any
}

protocol TableViewItemRegistration {
    var cellId: String { get }
    func setup(cell: UITableViewCell, at indexPath: IndexPath, with data: Any)
}

class ListView: UIView, UITableViewDataSource {
    
    private struct CellRegistration<Cell: UITableViewCell, Item>: TableViewItemRegistration {
        let cellId: String
        let setupClosure: (Cell, IndexPath, Item) -> Void
        
        func setup(cell: UITableViewCell, at indexPath: IndexPath, with data: Any) {
            setupClosure(cell as! Cell, indexPath, data as! Item)
        }
    }
    
    private let errorView: EmptyListView = {
        let view = EmptyListView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    var dataSource: DataSource?
   
    private var registeredItems: [String: TableViewItemRegistration] = [:]
    
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.attach(to: self)
        tableView.separatorStyle = .none
        tableView.dataSource = self
    }
    
    func reloadData() {
        tableView.reloadData()
    }
    
    func register<Item, Cell: UITableViewCell>(item: Item.Type, forCell: Cell.Type, setup: @escaping (Cell, IndexPath, Item) -> Void) {
        let cellId = String(describing: forCell)
        let regId = String(reflecting: item)
        tableView.register(forCell, forCellReuseIdentifier: cellId)
        registeredItems[regId] = CellRegistration(cellId: cellId, setupClosure: setup)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = self.dataSource?.item(at: indexPath) else {
            fatalError("")
        }
        let regId = String(reflecting: type(of: item))
        guard let registration = registeredItems[regId] else {
            fatalError("table view item registration \"\(regId)\" not found")
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: registration.cellId, for: indexPath)
        registration.setup(cell: cell, at: indexPath, with: item)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource?.numberOfSections() ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.numberOfItems(in: section) ?? 0
    }
    
    func showError(_ boolean: Bool) {
        if boolean {
            addSubview(errorView)
            NSLayoutConstraint.activate([
                errorView.centerXAnchor.constraint(equalTo: centerXAnchor),
                errorView.centerYAnchor.constraint(equalTo: centerYAnchor),
                errorView.heightAnchor.constraint(equalToConstant: 100),
                errorView.widthAnchor.constraint(equalToConstant: 100)
            ])
            tableView.isHidden = true
        } else {
            errorView.removeFromSuperview()
            tableView.isHidden = false
        }
    }
}

//
//  CryptoListViewController.swift
//  Spoton-Test
//
//  Created by Navroz on 19/06/21.
//

import UIKit
import Combine

class CryptoListViewController: UIViewController {
    // MARK: - Local variable
    private let table = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private let viewModal: CryptoViewModal = .init()
    private var subscriptions = Set<AnyCancellable>()
    private var stocks = [Stock]() {
        didSet {
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
    }
    private var filteredStocks = [Stock]() {
        didSet {
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationSetup()
        setupUI()
        bindViewModal()
    }
    
}

private extension CryptoListViewController {
    
    func setupUI() {
        view = table
        view.overrideUserInterfaceStyle = .dark

        table.register(StockCell.self, forCellReuseIdentifier: "StockCell")
        table.dataSource = self
        table.delegate = self
    }
    
     func navigationSetup() {
        self.title = "Crypto Currency"
        navigationController?.navigationBar.barTintColor = UIColor.black
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Crypto"
        searchController.searchBar.searchTextField.textColor = .white
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
    }
    
    func bindViewModal() {
         self.viewModal.$stocks.sink { [weak self] (stocks) in
            guard let stocks = stocks else { return }
            self?.stocks = stocks
         }.store(in: &subscriptions)
    }
}

extension CryptoListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredStocks.count : stocks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StockCell") as? StockCell else {
            fatalError("cell not configured")
        }
        
        let modal = isFiltering ? filteredStocks[indexPath.row] : stocks[indexPath.row]
        cell.configureCell(stock: modal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}

extension CryptoListViewController: UISearchResultsUpdating {
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard
            isSearchBarEmpty == false,
            let searchText = searchController.searchBar.text
        else {
            filteredStocks.removeAll()
            return
        }
        filteredStocks = filterStock(for: searchText)
    }
    
    func filterStock(for searchText: String) -> [Stock] {
        return stocks.filter {
            return ($0.name?.lowercased().contains(searchText.lowercased()) ?? false)
        }
    }

}

// TODO: Constant enum for static text

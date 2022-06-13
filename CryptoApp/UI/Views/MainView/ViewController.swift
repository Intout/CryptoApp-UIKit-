//
//  ViewController.swift
//  CryptoApp
//
//  Created by Mert Tecimen on 6.06.2022.
//

import UIKit

// In MVVM, viewController in UIkit counts as just View, not a controller!

class ViewController: UIViewController {

    @IBOutlet weak var widgetCollection: UICollectionView!
    @IBOutlet weak var cryptoTableView: UITableView!
    @IBOutlet weak var cryptoSearchBar: UISearchBar!
    
    // Helpers
    private var collectionViewHelper: CollectionViewHelper!
    private var tableViewHelper: TableViewHelper!
    private var navigationControllerHelper: NavigationControllerHelper!
    
    // View Model
    private var viewModel = MainViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationControllerHelper = NavigationControllerHelper(for: navigationController!, watchlistClouser:  didWatchlistChanged)
        collectionViewHelper = CollectionViewHelper(with: widgetCollection, in: viewModel)
        tableViewHelper = TableViewHelper(with: cryptoTableView, in: viewModel, to: navigationControllerHelper)
        
        tableViewHelper.navigationRequestDelegate = self
        
        viewModel.delegate = self
        viewModel.viewDidLoad()
        
        setupUI()
    }
    
    private func didWatchlistChanged(with id: String){
        viewModel.editFavourites(for: id)
        collectionViewHelper
    }
    
    private func setupUI(){
        

        cryptoSearchBar.delegate = self
        
        // Change text color in UISearchBar
        let textFieldSearchBar = cryptoSearchBar.value(forKey: "searchField") as? UITextField
        textFieldSearchBar?.textColor = .black
        
        
        //Refresh control on UITableView
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        cryptoTableView.refreshControl = refreshControl

        
    }
    
    @objc
    /// On action fetchData again then end refreshing.
    /// - Parameter refreshControl: Refresh Control usually send as self in addTarget function.
    private func refreshData(refreshControl: UIRefreshControl){
        viewModel.refreshData()
        print("Refreshed!")
        refreshControl.endRefreshing()
    }
    
}

extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        tableViewHelper.filterData(for: searchText)
        
    }
}

extension ViewController: WachtableDelegate{
    func editWatchList(new id: String) {
      //  dataModel.editToFavourites(new: id)
      //  collectionViewHelper.setData(datas: dataModel.getFavouritesDataFromCryptoDatas(data: CryptoDatas(data: tableViewHelper.cryptoData, timestamp: nil)))
    }
}

extension ViewController: MainViewModelDelegate{
    func didTableViewDataFetched(_ data: [TableViewCellModel]) {
        tableViewHelper.setData(with: data)
    }
    
    func didCollectionViewDataFetched(_ data: [CollectionViewCellModel]) {
        collectionViewHelper.setData(datas: data)
    }
    
    
}


extension ViewController: NavigationRequestDelegate{
    func didRequestNavigation(with index: Int) {
        var indexData = viewModel.fetchDetailsData(for: index)
        
        navigationControllerHelper.navigate(with: .init(name: indexData?.name ?? "-",
                                                        logoName: indexData?.symbol,
                                                        id: indexData?.id ?? " ",
                                                        price: indexData?.priceUsd ?? "0",
                                                        circulization: indexData?.supply ?? "0",
                                                        marketCap: indexData?.marketCapUsd ?? "0",
                                                        volume: indexData?.volumeUsd24Hr ?? "0.0",
                                                        changePercentage: indexData?.changePercent24Hr ?? "0.0"), isInWatchlist: viewModel.isInFavourites(for: indexData?.id ?? ""))
    }
}

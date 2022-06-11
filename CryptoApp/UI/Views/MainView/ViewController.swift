//
//  ViewController.swift
//  CryptoApp
//
//  Created by Mert Tecimen on 6.06.2022.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var widgetCollection: UICollectionView!
    
    @IBOutlet weak var cryptoTableView: UITableView!
    @IBOutlet weak var cryptoSearchBar: UISearchBar!
    
    private var dataModel = CryptoDataModel()
    private var collectionViewHelper: CollectionViewHelper!
    private var tableViewHelper: TableViewHelper!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewHelper = CollectionViewHelper(with: widgetCollection, in: self)
        tableViewHelper = TableViewHelper(with: cryptoTableView, in: self)
        dataModel.fetchData{ data in
            
            self.collectionViewHelper.setData(datas: self.dataModel.getFavouritesDataFromCryptoDatas(data: data))
            self.tableViewHelper.setData(with: data.data ?? [])
            
        }
       setupUI()
    }
    
    
    let defaults = UserDefaults.standard
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
        dataModel.fetchData{ data in
            
            self.collectionViewHelper.setData(datas: self.dataModel.getFavouritesDataFromCryptoDatas(data: data))
            self.tableViewHelper.setData(with: data.data ?? [])
            
        }
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
        dataModel.editToFavourites(new: id)
        collectionViewHelper.setData(datas: dataModel.getFavouritesDataFromCryptoDatas(data: CryptoDatas(data: tableViewHelper.cryptoData, timestamp: nil)))
    }
}

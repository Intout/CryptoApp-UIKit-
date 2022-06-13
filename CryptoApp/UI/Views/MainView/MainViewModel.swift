//
//  MainViewModel.swift
//  CryptoApp
//
//  Created by Mert Tecimen on 13.06.2022.
//

import Foundation

// Helper classes owned by View.
// Do not add UIKit elements to View Model


protocol MainViewModelDelegate: AnyObject{
    func didTableViewDataFetched(_ data: [TableViewCellModel])
    func didCollectionViewDataFetched(_ data: [CollectionViewCellModel])
}

protocol NavigationRequestDelegate: AnyObject{
    func didRequestNavigation(with index: Int)
}



class MainViewModel{
    
    private var mainViewDataModel = ViewControllerDataModel()
    weak var delegate: MainViewModelDelegate?
    
    
    
    init(){
        
    }
    
    func viewDidLoad(){
        fetchData()
    }
    
    func refreshData(){
        fetchData()
    }
    
    func fetchDetailsData(for index: Int) -> CryptoData?{
        return mainViewDataModel.getDataAt(for: index)
    }
    
    func isInFavourites(for id: String) -> Bool{
        return loadFavourites().contains(id)
    }
    
    private func saveFavourites(for newArray: [String]){
        mainViewDataModel.saveFavourites(new: newArray)
    }
    
    private func loadFavourites() -> [String]{
        return mainViewDataModel.loadFavourites()
    }
    
    func editFavourites(for id: String){
        var favourites = loadFavourites()
        
        if favourites.contains(id){
            saveFavourites(for: favourites.filter{
                $0 != id
            })
        } else {
            favourites.append(id)
            saveFavourites(for: favourites)
        }
        
        fetchData()
        
    }
    
    private func fetchData(){
        mainViewDataModel.fetchData{ data in
            
            // Table View Data
            let tableViewData: [TableViewCellModel] = (data.data ?? []).map{
                // Type Transfer
                TableViewCellModel.init(name: $0.name ?? "-",
                                        logoName: $0.symbol,
                                        changePercentage: self.formatPercentage(for: $0.changePercent24Hr ?? "0.0")
                )
            }
            self.delegate?.didTableViewDataFetched(tableViewData)
            
            // Collection View Data
            let favourites = self.loadFavourites()
            var collectionViewData: [CollectionViewCellModel] = []
            // Type Transfer if it's in favourites.
            for data in data.data ?? []{
                if favourites.contains(data.id ?? ""){
                    collectionViewData.append(CollectionViewCellModel.init(name: data.name ?? "-",
                                                     price: self.formatPrice(for: data.priceUsd ?? "0"),
                                                     logoName: data.symbol
                        ))
                }
            }
            self.delegate?.didCollectionViewDataFetched(collectionViewData)
        }
    }
}

// Data Formating
private extension MainViewModel{
    private func formatPrice(for price: String) -> String{
        return "$" +  String(format: "%.0f", (price as NSString).floatValue)
    }
    
    private func formatPercentage(for percentage: String) -> String{
        var percentageHolder = percentage
        if percentageHolder.contains("-"){
            percentageHolder.removeFirst()
            return "-%" +  String(format: "%.3f", (percentageHolder as NSString).floatValue)
        }
        return "%" +  String(format: "%.3f", (percentageHolder as NSString).floatValue)
    }
}

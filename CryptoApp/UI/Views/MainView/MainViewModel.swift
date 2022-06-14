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
        self.delegate?.didCollectionViewDataFetched(self.cryptoDataToCollectionViewData(for: mainViewDataModel.getRawData() ?? []))
    }
    
    private func fetchData(){
        mainViewDataModel.fetchData{
            // Table View Data
            self.delegate?.didTableViewDataFetched(self.cryptoDataToTableViewData(for: self.mainViewDataModel.getFilteredData() ?? []))
            
            // Collection View Data
            self.delegate?.didCollectionViewDataFetched(self.cryptoDataToCollectionViewData(for: self.mainViewDataModel.getRawData() ?? []))
        }
        
    }
}
// Search
extension MainViewModel{
    func search(for text: String){
        mainViewDataModel.filterData(for: text)
        self.delegate?.didTableViewDataFetched(self.cryptoDataToTableViewData(for: mainViewDataModel.getFilteredData() ?? []))
    }
}

// Data Formating
private extension MainViewModel{
    func formatPrice(for price: String) -> String{
        let priceValue: Float = (price as NSString).floatValue
        let format = priceValue < 1 ? "%.4f" : "%.1f"
        return "$" +  String(format: format, priceValue)
    }
    
    func formatPercentage(for percentage: String) -> String{
        var percentageHolder = percentage
        if percentageHolder.contains("-"){
            percentageHolder.removeFirst()
            return "-%" +  String(format: "%.3f", (percentageHolder as NSString).floatValue)
        }
        return "%" +  String(format: "%.3f", (percentageHolder as NSString).floatValue)
    }
}
// User Defaults.
private extension MainViewModel{
    func saveFavourites(for newArray: [String]){
        mainViewDataModel.saveFavourites(new: newArray)
    }
    
    func loadFavourites() -> [String]{
        return mainViewDataModel.loadFavourites()
    }
}

private extension MainViewModel{
    
    func cryptoDataToTableViewData(for cryptoDatas: [CryptoData]) -> [TableViewCellModel]{
        return (cryptoDatas).map{
            TableViewCellModel.init(name: $0.name ?? "-",
                                    logoName: $0.symbol,
                                    changePercentage: self.formatPercentage(for: $0.changePercent24Hr ?? "0.0")
            )
        }
    }
    
    func cryptoDataToCollectionViewData(for cryptoDatas: [CryptoData]) -> [CollectionViewCellModel]{
        let favourites = self.loadFavourites()
        var collectionViewData: [CollectionViewCellModel] = []
        // Type Transfer if it's in favourites.
        for data in cryptoDatas{
            if favourites.contains(data.id ?? ""){
                collectionViewData.append(CollectionViewCellModel.init(
                    name: data.name ?? "-",
                    price: self.formatPrice(for: data.priceUsd ?? "0"),
                    logoName: data.symbol
                ))
            }
        }
        return collectionViewData
    }
    
}

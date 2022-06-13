//
//  NavigationControllerHelper.swift
//  CryptoApp
//
//  Created by Mert Tecimen on 12.06.2022.
//

import UIKit

class NavigationControllerHelper{
    
    weak var navigationController: UINavigationController!
    var watchlistClouser: (() -> ())?
    init(for navigationController: UINavigationController, watchlistClouser: @escaping (()->())){
        self.navigationController = navigationController
        self.watchlistClouser = watchlistClouser
    }
    
    func navigate(with data: DetialViewDataModel) {
        if let viewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController{
            navigationController.pushViewController(viewController, animated: true)
            viewController.viewModel = DetailsViewModel(with: data)
            // viewController.isInWatchlist = favourites.contains(filteredCryptoDatas[indexPath.item].id ?? " ")
            //  viewController.delegate = self
            viewController.onWatchlistChanged = self.watchlistClouser
        }
    }
}

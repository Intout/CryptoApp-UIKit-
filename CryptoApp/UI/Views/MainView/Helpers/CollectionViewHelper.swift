//
//  CollectionViewHelper.swift
//  CryptoApp
//
//  Created by Mert Tecimen on 11.06.2022.
//

import Foundation
import UIKit


class CollectionViewHelper: NSObject{
    
    weak private var mainViewModel: MainViewModel?
    weak private var collectionView: UICollectionView?
    var favourites: [CollectionViewCellModel] = []
    let defaults = UserDefaults.standard
    
    init(with collectionView: UICollectionView, in vm: MainViewModel) {
        super.init()
        self.mainViewModel = vm
        self.collectionView = collectionView
        
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        
        registerCell()
    }
    
    private func registerCell(){
        self.collectionView?.register(.init(nibName: "FavouritesWidget", bundle: nil), forCellWithReuseIdentifier: "FavouritesWidget")
    }
    
    func setData(datas: [CollectionViewCellModel]){
        favourites = datas
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
    }
    
}

extension CollectionViewHelper: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 140, height: 140)
    }
}

extension CollectionViewHelper: UICollectionViewDelegate{
}

extension CollectionViewHelper: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favourites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView?.dequeueReusableCell(withReuseIdentifier: "FavouritesWidget", for: indexPath) as! FavouritesWidget
        
        cell.dropShadow(radius: 2.0, opacity: 0.4, offset: CGSize(width: 0, height: 3))

        if let imageName = favourites[indexPath.item].logoName{
            cell.iconImage.image = UIImage(named: imageName)
        }
        
        cell.nameLabel.text = favourites[indexPath.item].name
        cell.priceLabel.text = favourites[indexPath.item].price
        
        return cell
    }
}

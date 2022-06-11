//
//  CollectionViewHelper.swift
//  CryptoApp
//
//  Created by Mert Tecimen on 11.06.2022.
//

import Foundation
import UIKit


class CollectionViewHelper: NSObject{
    
    private var vc: UIViewController?
    private var collectionView: UICollectionView?
    var favourites: [CryptoData] = []
    let defaults = UserDefaults.standard
    
    init(with collectionView: UICollectionView, in vc: UIViewController) {
        super.init()
        self.vc = vc
        self.collectionView = collectionView
        
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        
        registerCell()
    }
    
    private func registerCell(){
        self.collectionView?.register(.init(nibName: "FavouritesWidget", bundle: nil), forCellWithReuseIdentifier: "FavouritesWidget")
    }
    
    func setData(datas: [CryptoData]){
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

        if let imageName = favourites[indexPath.item].symbol{
            cell.iconImage.image = UIImage(named: imageName)
        }
        
        cell.nameLabel.text = favourites[indexPath.item].name
        cell.priceLabel.text = "$" + String(format: "%.0f", (favourites[indexPath.item].priceUsd! as NSString ).floatValue)
        return cell
    }
}

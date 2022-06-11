//
//  FavouritesWidget.swift
//  CryptoApp
//
//  Created by Mert Tecimen on 6.06.2022.
//

import UIKit

class FavouritesWidget: UICollectionViewCell {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private(set) weak var priceLabel: UILabel!
    @IBOutlet private(set) weak var nameLabel: UILabel!
    @IBOutlet private(set) weak var iconImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupWidget()
    }
    
    private func setupWidget(){
        
        self.containerView.layer.cornerRadius = 25
    }

}

//
//  DetailsTableViewCell.swift
//  CryptoApp
//
//  Created by Mert Tecimen on 10.06.2022.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {

    @IBOutlet private(set) weak var containerView: UIView!
    @IBOutlet private(set) weak var titleLabel: UILabel!
    @IBOutlet private(set) weak var valueContainerView: UIView!
    @IBOutlet private(set) weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupNib()
    }

    private func setupNib(){
        containerView.layer.cornerRadius = 10
        valueContainerView.layer.cornerRadius = 10
        containerView.innerShadow(radius: 5.0, opacity: 0.8, offset: CGSize(width: 0.5, height: 0.5))
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 21, left: 5, bottom: 0, right: 5))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}

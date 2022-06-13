//
//  CryptoTableViewCell.swift
//  CryptoApp
//
//  Created by Mert Tecimen on 7.06.2022.
//

import UIKit

class CryptoTableViewCell: UITableViewCell {
    
    @IBOutlet private(set) weak var containerView: UIView!
    @IBOutlet private(set) weak var icon: UIImageView!
    @IBOutlet private(set) weak var nameLabel: UILabel!
    @IBOutlet private(set) weak var percentageLabel: UILabel!
    @IBOutlet private(set) weak var percentageView: UIView!
    @IBOutlet private(set) weak var directionImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupUI(){
        containerView.layer.cornerRadius = 25
        percentageView.layer.cornerRadius = 25
        
        percentageLabel.textColor = .white
        containerView.innerShadow(radius: 5.0, opacity: 0.8, offset: CGSize(width: 0.5, height: 0.5))

        let arrowImage = UIImage(systemName: "arrow.forward")
        directionImage.image = arrowImage
        directionImage.tintColor = .systemGray6
        
        
    }
    
    /// Update percentage frame according to fetched data. If data contains "-" view color is set to red and "-" char gets poped from string, new string value turns in to
    /// float then it turns in to "%.3f" format as string. if data doesn't contains "-" view color is set to green and value turns into "%.3f" string format.
    /// - Parameter percentage: Fetched percentage data. It should be in "-0.0" or "0.0" format.
    func updatePercentageSection(percentage: String){
        
        percentageView.backgroundColor = percentage.contains("-") ? .systemRed : .systemGreen
        percentageLabel.text = percentage
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 32, bottom: 10, right: 32))
    }
    
}

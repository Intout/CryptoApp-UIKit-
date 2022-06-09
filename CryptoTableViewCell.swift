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
        //containerView.backgroundColor = .gray
        
        let size = containerView.frame.size
        containerView.clipsToBounds = true
        let layer: CALayer = CALayer()
        layer.backgroundColor = UIColor.lightGray.cgColor
        layer.position = CGPoint(x: size.width / 2, y: -size.height / 2 + 0.5)
        layer.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        
        
        
        containerView.layer.addSublayer(layer)
        
        
        var arrowImage = UIImage(systemName: "arrow.forward")
        arrowImage?.withTintColor(.gray)
        directionImage.image = arrowImage
        
        
    }
    
    func updatePercentageSection(percentage: String){
        
        var value = percentage
        
        if percentage.contains("-"){
            percentageView.backgroundColor = .red
            value.removeFirst()
            percentageLabel.text = "-%" + String(format: "%.3f", (value as NSString).floatValue)
        } else {
            percentageView.backgroundColor = .green
            value.removeFirst()
            percentageLabel.text = "%" + String(format: "%.3f", (value as NSString).floatValue)
        }
        
        
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 32, bottom: 10, right: 32))
    }
    
}

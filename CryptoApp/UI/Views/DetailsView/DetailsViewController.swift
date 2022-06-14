//
//  DetailsViewController.swift
//  CryptoApp
//
//  Created by Mert Tecimen on 10.06.2022.
//

import UIKit


protocol WachtableDelegate: AnyObject{
    func editWatchList(new id:String)
}

class DetailsViewController: UIViewController {

    // Icon view
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var iconView: UIView!
    // Title
    @IBOutlet weak var titleLabel: UILabel!
    // Price and percentage
    @IBOutlet weak var priceBackgroundView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var changePercentageBackgroundView: UIView!
    @IBOutlet weak var changePercentage: UILabel!
    // Details Table
    @IBOutlet weak var detailsTableView: UITableView!
    
    
    
    var viewModel: DetailsViewModel!
    // Watchlist update.
    var isInWatchlist: Bool?
    var onWatchlistChanged: ((String)->())?
    
    private var detailsTableViewHelper: DetailsTableViewHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.detailsTableViewHelper = DetailsTableViewHelper(with: detailsTableView, in: viewModel)
        self.viewModel.delegate = self
        self.viewModel.viewDidLoad()
        
        setupUI()
    }
    
    @IBOutlet weak var watchlistButton: UIButton!
    private func setupUI(){
        
        self.watchlistButton.layer.cornerRadius = 10
        self.watchlistButton.dropShadow(radius: 5.0, opacity: 0.8, offset: CGSize(width: 0.5, height: 0.5))
        self.watchlistButton.didPressed(is: isInWatchlist ?? true, pressedColor: .white, nonPressedColor: .systemGray4, pressedText: "Add To Watchlist", nonPressedText: "Remove From Watchlist")
        
        
        iconView.layer.cornerRadius = iconView.frame.width / 2
        iconView.layer.borderWidth = 7
        iconView.layer.borderColor = UIColor.systemGray5.cgColor
        iconView.backgroundColor = UIColor.white
        iconView.dropShadow(radius: 2.0, opacity: 0.4, offset: CGSize(width: 0, height: 3))
        
        priceBackgroundView.layer.cornerRadius = 10
        
        changePercentageBackgroundView.layer.cornerRadius = 10
        changePercentageBackgroundView.innerShadow(radius: 5.0, opacity: 0.8, offset: CGSize(width: 0.5, height: 0.5))
            
        detailsTableView.dropShadow(radius: 2.0, opacity: 0.4, offset: CGSize(width: 0, height: 3))
        
    }
    
    func updatePercentageSectionBackground(for value: String){
        
        if value.contains("-"){
            changePercentageBackgroundView.backgroundColor = .systemRed
            priceBackgroundView.backgroundColor = UIColor(red: 255/255, green: 201/255, blue: 201/255, alpha: 1)
        } else {
            changePercentageBackgroundView.backgroundColor = .systemGreen
            priceBackgroundView.backgroundColor = UIColor(red: 201/255, green: 255/255, blue: 206/255, alpha: 1)
        }
        
    }
    
    @IBAction func watchlistButtonPressed(_ sender: Any) {
        self.isInWatchlist?.toggle()
        self.onWatchlistChanged?(viewModel.getID())
        
        self.watchlistButton.didPressed(is: isInWatchlist ?? true, pressedColor: .white, nonPressedColor: .systemGray4, pressedText: "Add To Watchlist", nonPressedText: "Remove From Watchlist")
    }
}

extension DetailsViewController: DetailsViewModelDelegate{
    func didDetailsHeaderFetched(_ data: DetailViewHeaderDataModel) {
        if let imageName = data.logoName {
            icon.image = UIImage(named: imageName)
        }
        titleLabel.text = data.name
        priceLabel.text = "$" + data.price
        changePercentage.text = data.changepercentage
        updatePercentageSectionBackground(for: data.changepercentage)
    }
    
    func didDetailsTableViewFetched(_ data: DetailsTableViewDataModel) {
        self.detailsTableViewHelper.setData(data)
    }
}

extension UIButton{
    func didPressed(is pressed: Bool, pressedColor: UIColor, nonPressedColor: UIColor, pressedText: String, nonPressedText: String){

        
        if pressed{
            self.backgroundColor = .systemGray4
            self.setTitle("Remove From Watchlist", for: .normal)
            self.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            self.setTitleColor(.white, for: .normal)        } else {
            self.backgroundColor = .white
            self.setTitle("Add To Watchlist", for: .normal)
            self.setImage(UIImage(systemName: "eye"), for: .normal)
            self.setTitleColor(.black, for: .normal)
        }
        self.reloadInputViews()
    }
}

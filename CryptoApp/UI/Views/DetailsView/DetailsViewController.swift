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

    var detailsDict: [String:String] = [:]
    var cryptoData: CryptoData?
    var isInWatchlist: Bool?
    var onWatchlistChanged: (()->())?
    weak var delegate: WachtableDelegate? = nil
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
    
    @IBOutlet weak var detailsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        setupUI()
        
        
    }
    
    @IBOutlet weak var watchlistButton: UIButton!
    private func initData(){
        detailsDict["Market Cap"] = "$" + (String(format: "%.0f", (cryptoData?.marketCapUsd as! NSString).floatValue) ?? "-")
        detailsDict["Volume (24hr)"] = "$" + (String(format: "%.0f", (cryptoData?.volumeUsd24Hr as! NSString ).floatValue) ?? "-")
        detailsDict["Circulization"] = (String(format: "%.0f", (cryptoData?.supply  as! NSString ).floatValue) ?? "-") + " \(String(describing: cryptoData?.symbol ?? "-"))"
    }
    private func setupUI(){
        
        if let imageName = cryptoData?.symbol{
            icon.image = UIImage(named: imageName)
        }
    
        self.watchlistButton.layer.cornerRadius = 10
        watchlistButton.layer.shadowColor = UIColor.black.cgColor
        watchlistButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        watchlistButton.layer.shadowOpacity = 0.4
        watchlistButton.layer.shadowRadius = 2.0
        watchlistButton.layer.masksToBounds = false
        
        self.watchlistButton.didPressed(is: isInWatchlist ?? true, pressedColor: .white, nonPressedColor: .systemGray4, pressedText: "Add To Watchlist", nonPressedText: "Remove From Watchlist")
        
        detailsTableView.register(.init(nibName: "DetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailsTableViewCell")
        
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        
        iconView.layer.cornerRadius = iconView.frame.width / 2
        iconView.layer.borderWidth = 7
        iconView.layer.borderColor = UIColor.systemGray5.cgColor
        iconView.backgroundColor = UIColor.white
        
        priceBackgroundView.layer.cornerRadius = 10
        changePercentageBackgroundView.layer.cornerRadius = 10
        titleLabel.text = cryptoData?.name ?? "-"
        priceLabel.text =  "$" + String(format: "%.2f", (cryptoData?.priceUsd as! NSString ).floatValue) ?? "-"
        
        changePercentageBackgroundView.innerShadow(radius: 5.0, opacity: 0.8, offset: CGSize(width: 0.5, height: 0.5))
            
        
        detailsTableView.layer.shadowColor = UIColor.black.cgColor
        detailsTableView.layer.shadowOffset = CGSize(width: 0, height: 3)
        detailsTableView.layer.shadowOpacity = 0.4
        detailsTableView.layer.shadowRadius = 2.0
        detailsTableView.layer.masksToBounds = false
        
        
        iconView.layer.shadowColor = UIColor.black.cgColor
        iconView.layer.shadowOffset = CGSize(width: 0, height: 3)
        iconView.layer.shadowOpacity = 0.4
        iconView.layer.shadowRadius = 2.0
        iconView.layer.masksToBounds = false
        
        updatePercentageSection()
        
    }
    
    func updatePercentageSection(){
        
        var value = cryptoData?.changePercent24Hr ?? "-0.0"
        
        if value.contains("-"){
            changePercentageBackgroundView.backgroundColor = .systemRed
            priceBackgroundView.backgroundColor = UIColor(red: 255/255, green: 201/255, blue: 201/255, alpha: 1)
            value.removeFirst()
            changePercentage.text = "-%" + String(format: "%.3f", (value as NSString).floatValue)
        } else {
            changePercentageBackgroundView.backgroundColor = .systemGreen
            priceBackgroundView.backgroundColor = UIColor(red: 201/255, green: 255/255, blue: 206/255, alpha: 1)
            value.removeFirst()
            changePercentage.text = "%" + String(format: "%.3f", (value as NSString).floatValue)
        }
        
        
    }
    
    
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


    @IBAction func watchlistButtonPressed(_ sender: Any) {
        self.isInWatchlist?.toggle()
        if delegate != nil{
            if let id = cryptoData?.id{
                delegate?.editWatchList(new: id)
            }
        }
        
        // clouser'ı
        self.onWatchlistChanged?()
        
        self.watchlistButton.didPressed(is: isInWatchlist ?? true, pressedColor: .white, nonPressedColor: .systemGray4, pressedText: "Add To Watchlist", nonPressedText: "Remove From Watchlist")
    }
    

}

extension DetailsViewController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        63
    }
}

extension DetailsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        detailsDict.keys.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsTableViewCell", for: indexPath) as! DetailsTableViewCell
        cell.backgroundColor = UIColor.systemGray5
        if detailsDict.isEmpty{
            cell.titleLabel.text = "-"
            cell.valueLabel.text = "-"
        } else {
            cell.titleLabel.text = Array(detailsDict.keys)[indexPath.item]
            cell.valueLabel.text = detailsDict[Array(detailsDict.keys)[indexPath.item]]
            
        }
        return cell
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

//
//  DetailsViewController.swift
//  CryptoApp
//
//  Created by Mert Tecimen on 10.06.2022.
//

import UIKit

class DetailsViewController: UIViewController {

    var detailsDict: [String:String] = [:]
    var cryptoData: CryptoData?
    
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
    
    private func initData(){
        detailsDict["Market Cap"] = "$" + (String(format: "%.0f", (cryptoData?.marketCapUsd as! NSString).floatValue) ?? "-")
        detailsDict["Volume (24hr)"] = "$" + (String(format: "%.0f", (cryptoData?.volumeUsd24Hr as! NSString ).floatValue) ?? "-")
        detailsDict["Circulization"] = (String(format: "%.0f", (cryptoData?.supply  as! NSString ).floatValue) ?? "-") + " \(String(describing: cryptoData?.symbol))"
    }
    private func setupUI(){
        
        if let imageName = cryptoData?.symbol{
            icon.image = UIImage(named: imageName)
        }
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

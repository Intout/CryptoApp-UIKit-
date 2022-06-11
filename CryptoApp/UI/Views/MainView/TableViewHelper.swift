//
//  TableViewHelper.swift
//  CryptoApp
//
//  Created by Mert Tecimen on 11.06.2022.
//

import Foundation
import UIKit

class TableViewHelper: NSObject{
    
    var vc: UIViewController?
    var tableView: UITableView?
    // Is this allowed?
    var cryptoData: [CryptoData] = []
    var filteredCryptoDatas: [CryptoData] = []
    
    init(with tableView: UITableView, in viewController: UIViewController) {
        super.init()
        self.vc = viewController
        self.tableView = tableView
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        
        registerCell()
        
    }
    
    private func registerCell(){
        self.tableView?.register(.init(nibName: "CryptoTableViewCell", bundle: nil), forCellReuseIdentifier: "CryptoTableViewCell")
    }
    
    func setData(with data: [CryptoData]){
        self.cryptoData = data
        self.filteredCryptoDatas = data
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
    // Is this Allowed?
    func filterData(for searchText: String){
        
        if searchText.count <= 2{
            self.filteredCryptoDatas = self.cryptoData
        } else {
            self.filteredCryptoDatas = cryptoData.filter{
                $0.name?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
        
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
    
}


extension TableViewHelper: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
}

extension TableViewHelper: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCryptoDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoTableViewCell", for: indexPath) as! CryptoTableViewCell
        
        if let imageName = filteredCryptoDatas[indexPath.item].symbol{
            cell.icon.image = UIImage(named: imageName)
        } else {
            
        }
        
        cell.nameLabel.text = filteredCryptoDatas[indexPath.item].name
        cell.updatePercentageSection(percentage: (filteredCryptoDatas[indexPath.item].changePercent24Hr)!)
        
        
        cell.backgroundColor = .systemGray6
        return cell
    }
    // Is this allowed?
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*
        if let viewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController{
            vc?.navigationController?.pushViewController(viewController, animated: true)
            viewController.cryptoData = filteredCryptoDatas[indexPath.item]
            viewController.isInWatchlist = favourites.contains(filteredCryptoDatas[indexPath.item].id ?? " ")
            viewController.delegate = self
        }
         */
    }
}

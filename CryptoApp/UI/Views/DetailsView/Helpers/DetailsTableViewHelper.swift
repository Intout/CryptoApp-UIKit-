//
//  DetailsTableViewHelper.swift
//  CryptoApp
//
//  Created by Mert Tecimen on 13.06.2022.
//

import Foundation
import UIKit

class DetailsTableViewHelper: NSObject{
    
    weak var viewModel: DetailsViewModel?
    weak var tableView: UITableView?
    private var data: DetailsTableViewDataModel?
    
    init(with tableView: UITableView, in viewModel: DetailsViewModel){
        super.init()
        self.viewModel = viewModel
        self.tableView = tableView
        
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        registerCell()
    }
    
    private func registerCell(){
        self.tableView?.register(.init(nibName: "DetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "DetailsTableViewCell")
    }
    
    func setData(_ data: DetailsTableViewDataModel){
        self.data = data
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
    
}


extension DetailsTableViewHelper: UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        63
    }
}

extension DetailsTableViewHelper: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsTableViewCell", for: indexPath) as! DetailsTableViewCell
        cell.backgroundColor = UIColor.systemGray5
        
        if indexPath.item == 0{
            cell.titleLabel.text = "Market Cap"
            cell.valueLabel.text = "$" + (self.data?.marketCap ?? "-")
        } else if indexPath.item == 1{
            cell.titleLabel.text = "Volume"
            cell.valueLabel.text = "$" + (self.data?.volume ?? "-")
        } else if indexPath.item == 2{
            cell.titleLabel.text = "Circulization"
            cell.valueLabel.text = self.data?.circulization ?? "-"
        }
        return cell
    }
    
    
}

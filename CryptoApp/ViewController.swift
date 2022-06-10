//
//  ViewController.swift
//  CryptoApp
//
//  Created by Mert Tecimen on 6.06.2022.
//

import UIKit


class ViewController: UIViewController {

    @IBOutlet weak var widgetCollection: UICollectionView!
    
    @IBOutlet weak var cryptoTableView: UITableView!
    @IBOutlet weak var cryptoSearchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
       setupUI()
    }
    
    private var cryptoDatas: CryptoDatas?
    private var filteredCryptoDatas: [CryptoData] = []
    private var favourites: [String] = ["bitcoin", "ethereum", "tether", "cardano", "decentraland"]
    private func setupUI(){
        
        widgetCollection.delegate = self
        widgetCollection.dataSource = self
        cryptoTableView.delegate = self
        cryptoTableView.dataSource = self
        cryptoSearchBar.delegate = self
        
        // Change text color in UISearchBar
        let textFieldSearchBar = cryptoSearchBar.value(forKey: "searchField") as? UITextField
        textFieldSearchBar?.textColor = .black
        
        widgetCollection.register(.init(nibName: "FavouritesWidget", bundle: nil), forCellWithReuseIdentifier: "FavouritesWidget")
        widgetCollection.clipsToBounds = false
        
        cryptoTableView.register(.init(nibName: "CryptoTableViewCell", bundle: nil), forCellReuseIdentifier: "CryptoTableViewCell")
        
        //Refresh control on UITableView
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        cryptoTableView.refreshControl = refreshControl

        
    }
    
    @objc
    /// On action fetchData again then end refreshing.
    /// - Parameter refreshControl: Refresh Control usually send as self in addTarget function.
    private func refreshData(refreshControl: UIRefreshControl){
        fetchData()
        print("Refreshed!")
        refreshControl.endRefreshing()
    }
    
    /// Makes URL request for given URL. After data fetch is successfull, UI components get refreshed in main thread.
    private func fetchData(){
        let url = URL(string: "https://api.coincap.io/v2/assets")
        
        let urlRequest = URLRequest(url: url!)
        
        
        URLSession.shared.dataTask(with: urlRequest){ [unowned self] data, response, error in
            
            if let error = error {
                print("DataTask error: " + error.localizedDescription + "\n")
            } else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                do{
                    //print(data.base64EncodedString())
                    let decodedData = try JSONDecoder().decode(CryptoDatas.self, from: data)
                    //print(decodedData)
                    self.cryptoDatas = decodedData
                    self.filteredCryptoDatas = decodedData.data ?? []
                    
                    for data in decodedData.data!{
                        print(data.symbol)
                    }
                    
                    DispatchQueue.main.async {
                        self.widgetCollection.reloadData()
                        self.cryptoTableView.reloadData()
                    }
                } catch {
                    print("Parsing failed!")
                }
            } else {
                print(response)
            }
            
        }.resume()
    }
    

}

extension ViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}


extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCryptoDatas.count ?? 0
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
    
}

extension ViewController: UICollectionViewDelegate{
    
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favourites.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController{
            navigationController?.pushViewController(viewController, animated: true)
            viewController.cryptoData = filteredCryptoDatas[indexPath.item]
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = widgetCollection.dequeueReusableCell(withReuseIdentifier: "FavouritesWidget", for: indexPath) as! FavouritesWidget
        // Change widget data here.
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 3)
        cell.layer.shadowOpacity = 0.4
        cell.layer.shadowRadius = 2.0
        cell.layer.masksToBounds = false
            
        if let data = cryptoDatas?.data?.filter({$0.id == favourites[indexPath.item]}).first{
            if let imageName = data.symbol{
                cell.iconImage.image = UIImage(named: imageName)
            }
            cell.nameLabel.text = data.name
            cell.priceLabel.text = "$" + String(format: "%.0f", (data.priceUsd! as NSString ).floatValue)
        } else {
            cell.nameLabel.text = "-"
            cell.priceLabel.text = "-"
        }
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 140, height: 140)
    }
}

extension ViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.count < 2{
            filteredCryptoDatas = cryptoDatas?.data ?? []
        } else {
            filteredCryptoDatas = cryptoDatas?.data?.filter{$0.name?.lowercased().contains(searchText.lowercased()) ?? false} ?? []
        }
        
        DispatchQueue.main.async {
            self.cryptoTableView.reloadData()
        }
    }
}

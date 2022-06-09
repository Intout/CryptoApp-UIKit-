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
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
       setupUI()
    }
    
    private var cryptoDatas: CryptoDatas?

    private func setupUI(){
        
        widgetCollection.delegate = self
        widgetCollection.dataSource = self
        cryptoTableView.delegate = self
        cryptoTableView.dataSource = self

        
        widgetCollection.register(.init(nibName: "FavouritesWidget", bundle: nil), forCellWithReuseIdentifier: "FavouritesWidget")
        
        cryptoTableView.register(.init(nibName: "CryptoTableViewCell", bundle: nil), forCellReuseIdentifier: "CryptoTableViewCell")
        
        widgetCollection.clipsToBounds = false

        
    }
    
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
                    print(data.base64EncodedString())
                    let decodedData = try JSONDecoder().decode(CryptoDatas.self, from: data)
                    print(decodedData)
                    self.cryptoDatas = decodedData
                    DispatchQueue.main.async {
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
        return 64
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}


extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoDatas?.data?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoTableViewCell", for: indexPath) as! CryptoTableViewCell
        
        cell.nameLabel.text = cryptoDatas?.data![indexPath.item].name
        cell.updatePercentageSection(percentage: (cryptoDatas?.data![indexPath.item].changePercent24Hr)!)
        
        
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegate{
    
}

extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = widgetCollection.dequeueReusableCell(withReuseIdentifier: "FavouritesWidget", for: indexPath) as! FavouritesWidget
        // Change widget data here.
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 3)
        cell.layer.shadowOpacity = 0.4
        cell.layer.shadowRadius = 2.0
        cell.layer.masksToBounds = false
        return cell
    }
    
    
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 140, height: 140)
    }
    
    
    
}

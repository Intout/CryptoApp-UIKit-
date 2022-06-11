//
//  CryptoDataModel.swift
//  CryptoApp
//
//  Created by Mert Tecimen on 11.06.2022.
//

import Foundation


class CryptoDataModel{
    
    private let url = URL(string: "https://api.coincap.io/v2/assets")
    private let defaults = UserDefaults.standard
    
    func fetchData(complationHandler: @escaping (CryptoDatas) -> (Void)){
        
        let urlRequest = URLRequest(url: url!)
        
        
        URLSession.shared.dataTask(with: urlRequest){ [unowned self] data, response, error in
            
            if let error = error {
                print("DataTask error: " + error.localizedDescription + "\n")
            } else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                do{
                    let decodedData = try JSONDecoder().decode(CryptoDatas.self, from: data)
                    
                    complationHandler(decodedData)
                    return
                    
                    for data in decodedData.data!{
                        print(data.symbol)
                    }
                } catch {
                    print("Parsing failed!")
                }
            } else {
                print(response)
            }
            
        }.resume()
    }
    
    func saveFavourites(new favourites: [String]){
        self.defaults.set(favourites, forKey: "Favourites")
    }
    
    func editToFavourites(new id: String){
        var favourites = loadFavourites()
        
        if favourites.contains(id){
            saveFavourites(new: favourites.filter{ $0 != id})
        } else {
            favourites.append(id)
            saveFavourites(new: favourites)
        }
        
    }
    
    func loadFavourites() -> [String]{
        return defaults.object(forKey: "Favourites") as? [String] ?? []
    }
    

    
    func getFavouritesDataFromCryptoDatas(data: CryptoDatas) -> [CryptoData]{
        var favourites = self.loadFavourites()
        return data.data?.filter{
            favourites.contains($0.id ?? "")
        } ?? []
    }
    
}

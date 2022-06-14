//
//  CryptoDataModel.swift
//  CryptoApp
//
//  Created by Mert Tecimen on 11.06.2022.
//

import Foundation


class ViewControllerDataModel{
    
    private let url = URL(string: "https://api.coincap.io/v2/assets")
    private let defaults = UserDefaults.standard
    
    private var rawData: [CryptoData]?
    private var filteredRawModel: [CryptoData]?
    
    func fetchData(completaionHandler: @escaping (()->())){
        
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
                    
                    self.rawData = decodedData.data
                    self.filteredRawModel = decodedData.data
                    completaionHandler()
                    return
                } catch {
                    print("Parsing failed!")
                }
            } else {
                print(response as Any)
            }
            
        }.resume()
    }
    
    func getFilteredData() -> [CryptoData]?{
        return self.filteredRawModel
    }
    
    func getRawData() -> [CryptoData]?{
        return self.rawData
    }
    
    func getDataAt(for index: Int) -> CryptoData?{
        return self.filteredRawModel?[index]
    }
    
}


// Mark:- User defaults processes.
extension ViewControllerDataModel{
    func saveFavourites(new favourites: [String]){
        print("Saved \(favourites)")
        self.defaults.set(favourites, forKey: "Favourites")
    }
    
    func loadFavourites() -> [String]{
        return defaults.object(forKey: "Favourites") as? [String] ?? []
    }
}

// Mark:- Search process.
extension ViewControllerDataModel{
    func filterData(for text: String) -> [CryptoData]?{
        if text.count < 3{
            self.filteredRawModel = self.rawData
        } else {
            self.filteredRawModel = self.rawData?.filter{
                $0.name!.lowercased().contains(text.lowercased())
            }
        }
        return self.filteredRawModel
    }
}

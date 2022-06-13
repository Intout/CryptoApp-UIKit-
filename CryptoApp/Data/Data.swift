//
//  Data.swift
//  CryptoApp
//
//  Created by Mert Tecimen on 8.06.2022.
//

import Foundation

struct CryptoDatas: Codable {
    let data: [CryptoData]?
    let timestamp: Int?
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
        case timestamp = "timestamp"
    }
}

// MARK: - Datum
struct CryptoData: Codable {
    let id: String?
    let rank: String?
    let symbol: String?
    let name: String?
    let supply: String?
    let maxSupply: String?
    let marketCapUsd: String?
    let volumeUsd24Hr: String?
    let priceUsd: String?
    let changePercent24Hr: String?
    let vwap24Hr: String?
    let explorer: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case rank = "rank"
        case symbol = "symbol"
        case name = "name"
        case supply = "supply"
        case maxSupply = "maxSupply"
        case marketCapUsd = "marketCapUsd"
        case volumeUsd24Hr = "volumeUsd24Hr"
        case priceUsd = "priceUsd"
        case changePercent24Hr = "changePercent24Hr"
        case vwap24Hr = "vwap24Hr"
        case explorer = "explorer"
    }
}

struct CollectionViewCellModel{
    let name: String
    let price: String
    let logoName: String?
}

struct TableViewCellModel{
    let name: String
    let logoName: String?
    let changePercentage: String
}

struct DetialViewDataModel{
    let name: String
    let logoName: String?
    let id: String
    let price: String
    let circulization: String
    let marketCap: String
    let volume: String
    let changePercentage: String
}

struct DetailsTableViewDataModel{
    let marketCap: String
    let circulization: String
    let volume: String
}

struct DetailViewHeaderDataModel{
    let name: String
    let logoName: String?
    let id: String
    let price: String
    let changepercentage:String
}

//
//  DetailsViewModel.swift
//  CryptoApp
//
//  Created by Mert Tecimen on 13.06.2022.
//

import Foundation

protocol DetailsViewModelDelegate: AnyObject{
    func didDetailsHeaderFetched(_ data: DetailViewHeaderDataModel)
    func didDetailsTableViewFetched(_ data: DetailsTableViewDataModel)
}


class DetailsViewModel{
    
    private var detailsViewDataModel: DetialViewDataModel?
    weak var delegate: DetailsViewModelDelegate?
    
    
    init(with data: DetialViewDataModel){
        detailsViewDataModel = data
    }
    
    func getID() -> String{
        return detailsViewDataModel?.id ?? ""
    }
    
    func viewDidLoad(){
        self.delegate?.didDetailsHeaderFetched(.init(name: self.detailsViewDataModel?.name ?? "-",
                                                     logoName: self.detailsViewDataModel?.logoName,
                                                     id: self.detailsViewDataModel?.id ?? "",
                                                     price: formatPrice(for: self.detailsViewDataModel?.price ?? "0"),
                                                     changepercentage: formatPercentage(for: self.detailsViewDataModel?.changePercentage ?? "0.0")))
        
        self.delegate?.didDetailsTableViewFetched(.init(
            marketCap: self.formatPrice(for: detailsViewDataModel?.marketCap ?? "0"),
            circulization: formatPrice(for: self.detailsViewDataModel?.circulization ?? "0"),
            volume: formatPrice(for: self.detailsViewDataModel?.volume ?? "0")))
        
    }
    
    
}

private extension DetailsViewModel{
    
    func formatPrice(for price: String) -> String{
        let priceValue: Float = (price as NSString).floatValue
        let format = priceValue < 1 ? "%.4f" : "%.1f"
        return String(format: format, priceValue)
    }
    
    private func formatPercentage(for percentage: String) -> String{
        var percentageHolder = percentage
        if percentageHolder.contains("-"){
            percentageHolder.removeFirst()
            return "-%" +  String(format: "%.3f", (percentageHolder as NSString).floatValue)
        }
        return "%" +  String(format: "%.3f", (percentageHolder as NSString).floatValue)
    }
    
}

//
//  UIView+Extensions.swift
//  CryptoApp
//
//  Created by Mert Tecimen on 11.06.2022.
//

import UIKit

extension UIView{
    func innerShadow(radius shadowRaidus: CGFloat, opacity shadowOpacity: Float, offset shadowOffset: CGSize){
        let size = self.frame.size
        self.clipsToBounds = true
        let innerShadowLayer: CALayer = CALayer()
        innerShadowLayer.backgroundColor = UIColor.lightGray.cgColor
        innerShadowLayer.position = CGPoint(x: size.width / 2, y: -size.height / 2 + 0.5)
        innerShadowLayer.bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        innerShadowLayer.shadowColor = UIColor.darkGray.cgColor
        innerShadowLayer.shadowOffset = shadowOffset
        innerShadowLayer.shadowOpacity = shadowOpacity
        innerShadowLayer.shadowRadius = shadowRaidus
        self.layer.addSublayer(innerShadowLayer)
    }
    
    func dropShadow(radius shadowRaidus: CGFloat, opacity shadowOpacity: Float, offset shadowOffset: CGSize){
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = shadowRaidus
        self.layer.masksToBounds = false
    }
}

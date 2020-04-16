//
//  PromotionTableViewCell.swift
//  Scandit iOS
//
//  Created by Alejandro Docasal on 20/03/2020.
//  Copyright © 2020 IECISA. All rights reserved.
//

import UIKit

class PromotionTableViewCell: UITableViewCell {

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: DesignableLabel!
    @IBOutlet weak var newPriceLabel: DesignableLabel!
    @IBOutlet weak var sizeImage: UIImageView!
    @IBOutlet weak var sizeLabel: DesignableLabel!
    @IBOutlet weak var seasonImage: UIImageView!
    @IBOutlet weak var seasonNumberLabel: DesignableLabel!
    @IBOutlet weak var stockImage: UIImageView!
    @IBOutlet weak var offerImage: UIImageView!
    @IBOutlet weak var offerLabel: DesignableLabel!
    @IBOutlet weak var numberStock: DesignableLabel!
    @IBOutlet weak var promotionLabel: UILabel!
    
    var product = Product()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initImages()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initImages(){
        sizeImage.image = sizeImage.image?.withRenderingMode(.alwaysTemplate)
        sizeImage.tintColor = UIColor.init(named: "primaryColor")
        
        seasonImage.image = seasonImage.image?.withRenderingMode(.alwaysTemplate)
        seasonImage.tintColor = UIColor.init(named: "primaryColor")
        
        stockImage.image = stockImage.image?.withRenderingMode(.alwaysTemplate)
        stockImage.tintColor = UIColor.init(named: "primaryColor")
        
        offerImage.image = offerImage.image?.withRenderingMode(.alwaysTemplate)
        offerImage.tintColor = UIColor.init(named: "primaryColor")
    }
    
}

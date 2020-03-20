//
//  ConsultProductTableViewCell.swift
//  Scandit iOS
//
//  Created by Alejandro Docasal on 19/03/2020.
//  Copyright © 2020 IECISA. All rights reserved.
//

import UIKit

class ConsultProductTableViewCell: UITableViewCell {

    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var priceLabel: DesignableLabel!
    @IBOutlet weak var stateLabel: DesignableLabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var sizeImage: UIImageView!
    @IBOutlet weak var seasonImage: UIImageView!
    @IBOutlet weak var stockImage: UIImageView!
    @IBOutlet weak var offerImage: UIImageView!
    @IBOutlet weak var seasonNumberLabel: DesignableLabel!
    @IBOutlet weak var stockNumberLabel: DesignableLabel!
    @IBOutlet weak var offerLabel: DesignableLabel!
    
    var product = DouglasProduct()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initView(){
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

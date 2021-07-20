//
//  ProductTableViewCell.swift
//  Scandit iOS
//
//  Created by Luis Martínez Moreno on 26/03/21.
//  Copyright © 2021 IECISA. All rights reserved.
//

import UIKit
import Combine

class ProductTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var productCodeLabel: UILabel!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        stepper.maximumValue = 9999
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func stepperAction(_ sender: UIStepper) {
        self.quantityLabel.text! = Int(sender.value).description
    }
}

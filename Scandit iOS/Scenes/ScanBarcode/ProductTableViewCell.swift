//
//  ProductTableViewCell.swift
//  Scandit iOS
//
//  Created by Alejandro Docasal on 18/03/2020.
//  Copyright © 2020 IECISA. All rights reserved.
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

        // Configure the view for the selected state
    }

    @IBAction func stepperAction(_ sender: UIStepper) {
        self.quantityLabel.text! = Int(sender.value).description
    }
}

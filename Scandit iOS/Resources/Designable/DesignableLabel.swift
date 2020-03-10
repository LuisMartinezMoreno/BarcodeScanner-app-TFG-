//
//  DesignableLabel.swift
//  Scandit iOS
//
//  Created by 67883058 on 06/03/2020.
//  Copyright © 2020 IECISA. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DesignableLabel : UILabel {
    
    @IBInspectable var cornerRadiusOfLabel : CGFloat = 0 {
        didSet{
            layer.cornerRadius = cornerRadiusOfLabel
        }
    }
    
    @IBInspectable var width: CGFloat = 0 {
        didSet {
            layer.borderWidth = width
        }
    }
    
    @IBInspectable var color: UIColor? {
        didSet {
                layer.borderColor = color?.cgColor
        }
    }
}

//
//  DesignableButton.swift
//  Scandit iOS
//
//  Created by 67883058 on 05/03/2020.
//  Copyright © 2020 IECISA. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DesignableButton : UIButton {
    
    @IBInspectable var cornerRadiusOfButton : CGFloat = 0 {
        didSet{
            layer.cornerRadius = cornerRadiusOfButton
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
    
    @IBInspectable var adjustText: Bool = false {
        didSet {
            self.titleLabel?.adjustsFontSizeToFitWidth = adjustText
            self.titleLabel?.baselineAdjustment = .alignCenters
            self.titleLabel?.lineBreakMode = .byClipping
        }
    }
    
}

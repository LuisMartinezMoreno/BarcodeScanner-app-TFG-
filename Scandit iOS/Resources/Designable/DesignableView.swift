//
//  DesignableView.swift
//  Scandit iOS
//
//  Created by 67883058 on 04/03/2020.
//  Copyright © 2020 IECISA. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DesignableView : UIView {
    
    @IBInspectable var cornerRadiusOfView : CGFloat = 0 {
        didSet{
            layer.cornerRadius = cornerRadiusOfView
        }
    }
    
    @IBInspectable var width : CGFloat = 0 {
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

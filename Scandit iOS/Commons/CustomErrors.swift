//
//  CustomErrors.swift
//  Scandit iOS
//
//  Created by Luis Martínez Moreno on 01/04/21.
//  Copyright © 2021 IECISA. All rights reserved.
//

import Foundation

enum CustomErrors : Error {
    case noQuantity
    
    var localizedDescription: String {
        switch self {
        case .noQuantity:
            return NSLocalizedString("Introduce una cantidad por favor", comment: "Introduce una cantidad por favor")
        }
    }
}

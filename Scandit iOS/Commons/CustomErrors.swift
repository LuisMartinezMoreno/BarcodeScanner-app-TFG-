//
//  CustomErrors.swift
//  Scandit iOS
//
//  Created by Alejandro Docasal on 16/03/2020.
//  Copyright © 2020 IECISA. All rights reserved.
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

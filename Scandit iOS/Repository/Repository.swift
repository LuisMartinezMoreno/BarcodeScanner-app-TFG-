//
//  Repository.swift
//  Scandit iOS
//
//  Created by Alejandro Docasal on 16/03/2020.
//  Copyright © 2020 IECISA. All rights reserved.
//

import Foundation

protocol Repository : class {
    associatedtype ProductType
    
    func readProducts(completion: @escaping ([ProductType]) -> Void) -> Void
}

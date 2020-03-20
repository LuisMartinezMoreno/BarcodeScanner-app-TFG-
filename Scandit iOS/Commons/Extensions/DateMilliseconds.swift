//
//  DateMilliseconds.swift
//  Scandit iOS
//
//  Created by Alejandro Docasal on 20/03/2020.
//  Copyright © 2020 IECISA. All rights reserved.
//

import Foundation

extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

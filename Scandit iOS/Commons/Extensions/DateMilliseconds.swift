//
//  DateMilliseconds.swift
//  Scandit iOS
//
//  Created by Luis Martínez Moreno on 20/3/21.
//  Copyright © 2021 IECISA. All rights reserved.
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

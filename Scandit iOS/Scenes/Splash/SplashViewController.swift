//
//  SplashViewController.swift
//  Scandit iOS
//
//  Created by Luis Martínez Moreno on 09/04/21.
//  Copyright © 2021 IECISA. All rights reserved.
//

import Foundation
import UIKit

class SplashViewController: UIViewController{
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.performSegue(withIdentifier: "initialSegue", sender: self)
    }
}

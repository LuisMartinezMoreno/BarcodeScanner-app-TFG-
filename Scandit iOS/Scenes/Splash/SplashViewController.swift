//
//  SplashViewModel.swift
//  Scandit iOS
//
//  Created by 67883058 on 09/03/2020.
//  Copyright © 2020 IECISA. All rights reserved.
//

import Foundation
import UIKit

class SplashViewController: UIViewController{
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.performSegue(withIdentifier: "initialSegue", sender: self)
    }
}

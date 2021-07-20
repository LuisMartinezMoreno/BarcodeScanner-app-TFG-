//
//  ScanditLicense.swift
//  Scandit iOS
//
//  Created by Luis Martínez Moreno on 30/05/21.
//  Copyright © 2021 IECISA. All rights reserved.
//

import Foundation
import ScanditBarcodeCapture

extension DataCaptureContext {
    
    private static let SCANDIT_LICENSE = "AS7wmy+6D1MXLsecBRdeMQ8r/yC7ImssZED4WkM/fpxXQFECSwul3ABke5zleVUeMFheRTE5So6ge49uiEQLsWxqHXJTVeRfADGliYJk0rRVbwpqzFQZFeUvyFhiC4GKfQbNlAomGrTfKP6MdzFRcObbvlGHCdpGDn7ugM0aXuc+Koo9r8W/Up+E/93ZUotP8ZSG4VekDHKUYxPvYa+E/XE4I+MFlcx2Dzn3IZ2hMTIJ0kLHRjPuWN7Qb1h+IfBUXIshUYHvMO9oMH6vzCNgcLXOA8oN3xC5ED3c6gtDuOW6ydMnAQUiVOg8AjbWSgpHBzyQ+qBdvYjpolpd2jjUjKUbjf2SXFizrctGzD5qj8969Zwd46wOT3NChs9RNiuaAGPxLZgJEECJukBadpLNPnjj23zXulXpH+wBOaf5xotAngLwVx1mpBEIrZ0fWtZtjmvdGg+/Q0XeRwSkMvZ3vnfwEuuEtipoyO0B4kQO2M7cl3ZNFTTRcAQG/sKbSpRxhsfMtBeE37uDkSwBTrlpOiKa4NFXUt/+ymwHxGuXR/PPD4v16jPPclw3IwLdf1s9rCKu9htzB4hXP2eF3tHM//Sf5GWqRWoR3whxi0i3OXz+vX0IXc5mU5WZ+YQDgazeI3a3/+RGv86O3cvHtRIL+M2K0W72fDIjPR4MzOlM29UK5yAOMhnPYlh8rUtWuqeTQUeNhsK4LPyI/T+lShoXvfn9410fJaF3TPgsg0mkgseC40IeAYOXfbMx7+dPVb7Ek8wS9RdFzljRRyq4IKbxsPQNWRXCAIX8pGReck0xohMoQGpj3IHFjRjox4To7Q=="
    static let licensed = DataCaptureContext(licenseKey: SCANDIT_LICENSE)
}

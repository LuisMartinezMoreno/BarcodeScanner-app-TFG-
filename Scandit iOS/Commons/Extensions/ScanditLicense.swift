//
//  ScanditLicense.swift
//  Scandit iOS
//
//  Created by Alejandro Docasal on 13/03/2020.
//  Copyright © 2020 IECISA. All rights reserved.
//

import Foundation
import ScanditBarcodeCapture

extension DataCaptureContext {
    
    private static let SCANDIT_LICENSE = "ATHeMQ6+EN62IbZGcT18VmwTvCL0BrRJpVucYmdGKA4HIuWiV0A84HYQCoSiffPbL2OCUAVesjamb+bnXiFBiqRh+KBbJ4y7QAJlAGZStnedNQJ0IGj1HBMr3iYZCXozCR0pjyMO8wBTJzg4YBMdK8Mo4mejBsJnMqsEIZtHUTf6fzZ5QIOadT62XXcmekxS5FG8SUrRfPE6pth3iFaRJYmQv8cPlX3gDjMqkj9O0G9Dskorke2frXKQJJK3Jtuoa+quA62YkEaYezHkle4AGyTuvija0UWCV4zY+4kv0MDxkeinRQtmiKwOI+PYRR2V1DrqoxsVtBMuXE4/WezGDu3bE2U8BmxUWGX9fgFCTH8uxQ11mSehDOCtm/IwgTJ1e39bMmSfiy6wzLsDeJDBBjhxHenkLFYP4S9bLDxd/W3rKrYff33MAT7HeQ6MVH0fg93hH4Bt8WduZU/B2fi0qH6gEcaFYrcdpni2b1zsbmvmDlBMr0W5ktZ3rS0LuCN+TE81pT3Rn7JHrdxpeRgA4A3gf3fSHPRk8zDO7hpnDAN1D/AD/uqnjVHSfyyfVPOuN7Bcnz5YgoqLio3d/dPzTupAITE+KG5y6pbabj/v7X1ciuFQ/dbaxTaWaVv9ePBciohm6ir9sMVqEtQoRAAXlKzYxL9G9npkueLkLdGPZEgQIt/LFxg2WUesTqmZMsl65gSC/5jurKzKZsaWXxLk/HiDe3YLo6K0g610oA43+bpgaH3qkv/jqAX5eOCw1evXLSAEyYRGHagsXrn8dod+5aXTx4IN6qyXFwd+bPA0qJx14f7Lde4rDEs7"
    static let licensed = DataCaptureContext(licenseKey: SCANDIT_LICENSE)
}
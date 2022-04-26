//
//  CTCarrier+Extension.swift
//  DFINERY-SDK
//
//  Created by 이영우 on 2022/04/26.
//

import CoreTelephony

public protocol CTCarrierLogic {
  var carrierName: String? { get }
}

extension CTCarrier: CTCarrierLogic { }

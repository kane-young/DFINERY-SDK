//
//  FakeCarrier.swift
//  DFINERY-SDKTests
//
//  Created by 이영우 on 2022/04/26.
//

import Foundation
import DFINERY_SDK

final class FakeCarrier: CTCarrierLogic {
  var carrierName: String?

  init(carrierName: String?) {
    self.carrierName = carrierName
  }
}

//
//  UserAdvertisement.swift
//  DFINERY-SDK
//
//  Created by 이영우 on 2022/04/25.
//

import Foundation

struct UserAdvertisement {
  static let defaultIdentifier = "00000000-0000-0000-0000-000000000000"

  var enableGettingIDFA: Bool
  var appleAdvertisingIdentifier: String

  init(enableGettingIDFA: Bool = false, appleAdvertisingIdentifier: String = UserAdvertisement.defaultIdentifier) {
    self.enableGettingIDFA = enableGettingIDFA
    self.appleAdvertisingIdentifier = appleAdvertisingIdentifier
  }
}

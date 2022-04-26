//
//  FakeDevice.swift
//  DFINERY-SDKTests
//
//  Created by 이영우 on 2022/04/26.
//

import UIKit
import DFINERY_SDK

final class FakeDevice: UIDeviceLogic {
  var systemVersion: String = "4.4.4"
  var name: String = "iPhone8"
  var orientation: UIDeviceOrientation = .portrait

  init(systemVersion: String, name: String, orientation: UIDeviceOrientation) {
    self.systemVersion = systemVersion
    self.name = name
    self.orientation = orientation
  }
}

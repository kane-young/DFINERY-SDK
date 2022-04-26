//
//  FakeScreen.swift
//  DFINERY-SDKTests
//
//  Created by 이영우 on 2022/04/26.
//

import UIKit
import DfineryAnalytics

final class FakeScreen: UIScreenLogic {
  var nativeBounds: CGRect

  init(width: Double, height: Double) {
    self.nativeBounds = CGRect(x: 0, y: 0, width: width, height: height)
  }
}

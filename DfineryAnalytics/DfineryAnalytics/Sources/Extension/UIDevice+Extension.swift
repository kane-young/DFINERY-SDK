//
//  UIDevice+Extension.swift
//  DFINERY-SDK
//
//  Created by 이영우 on 2022/04/25.
//

import UIKit

protocol UIDeviceLogic {
  var systemVersion: String { get }
  var name: String { get }
  var orientation: UIDeviceOrientation { get }
}

extension UIDevice: UIDeviceLogic { }

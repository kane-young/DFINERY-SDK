//
//  UIScreen.swift
//  DFINERY-SDK
//
//  Created by 이영우 on 2022/04/25.
//

import UIKit

protocol UIScreenLogic {
  var nativeBounds: CGRect { get }
}

extension UIScreen: UIScreenLogic { }
